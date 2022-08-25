{ config, lib, pkgs, ... }: with lib; let
  cfg = config.networking.firewall-tailored;
  portType = with types; oneOf [ int str ];
  portModule = types.submodule ({ ... }: {
    options.port = mkOption { type = portType; };
    options.protocols = mkOption { type = types.str; };
    options.predicate = mkOption { type = types.nullOr types.str; default = null; };
    options.comment = mkOption { type = types.nullOr types.str; default = null; };
  });
  AddrGroupModule = types.submodule ({ ... }: {
    options.addrs = mkOption { type = types.listOf types.str; };
    options.comment = mkOption { type = types.nullOr types.str; default = null; };
    options.countPackets = mkOption { type = types.bool; default = true; };
  });
in {
  options.networking.firewall-tailored = {
    enable = mkEnableOption "Tailored firewall module";
    acceptedPorts = mkOption { type = types.listOf (types.oneOf [ portType portModule ]); default = []; };
    rejectedAddrGroups = mkOption { type = types.listOf AddrGroupModule; default = []; };
    extraRulesAfter = mkOption { type = types.listOf types.lines; default = []; };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = config.networking.firewall.enable == false;
      message = "nftables is not meant to be used with iptables.  networking.firewall.enable must be set to false.";
    } {
      assertion = config.networking.nftables.enable == false;
      message = "networking.firewall-tailored conflicts with networking.nftables.  networking.nftables must be set to false.";
    }];
    networking.firewall.enable = false;
    networking.nftables.enable = false;
    boot.blacklistedKernelModules = [ "ip_tables" ];
    environment.systemPackages = [ pkgs.nftables ];
    sops.templates.nftables-rules.content = ''
flush ruleset

table inet filter
delete table inet filter
table inet filter {
  chain input {
    type filter hook input priority filter
    policy drop

    ct state invalid drop comment "early drop of invalid connections"
    ct state {established, related} accept comment "allow tracked connections"
    iifname lo accept comment "allow from loopback"
    ip protocol icmp accept comment "allow icmp"

    ${concatStringsSep "\n    " (map (addrGroup:
      "ip saddr {${concatStringsSep "," addrGroup.addrs}} ${if addrGroup.countPackets
        then "counter"
        else ""
      } drop ${if (addrGroup.comment != null)
        then "comment \"${addrGroup.comment}\""
        else ""
      }")
      cfg.rejectedAddrGroups)}

    meta l4proto ipv6-icmp accept comment "allow icmp v6"

    ${concatStringsSep "\n    " (map (portInfo: with builtins;
    if (((typeOf portInfo) == "int") || ((typeOf portInfo) == "string"))
      then "meta l4proto {tcp,udp} th dport ${portInfo} accept"
      else "${if (portInfo.predicate != null)
          then portInfo.predicate
          else ""
        } meta l4proto {${portInfo.protocols}} th dport ${toString portInfo.port} accept ${if (portInfo.comment != null)
          then "comment \"${portInfo.comment}\""
          else ""
        }"
      )
    cfg.acceptedPorts)}

    pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    counter
  }
}

${concatStringsSep "\n" cfg.extraRulesAfter}
      '';
    systemd.services.nftables = {
      description = "nftables firewall";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadIfChanged = true;
      serviceConfig = let
        ruleFilePath = config.sops.templates.nftables-rules.path;
      in {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.nftables}/bin/nft -f ${ruleFilePath}";
        ExecReload = "${pkgs.nftables}/bin/nft -f ${ruleFilePath}";
        ExecStop = "${pkgs.nftables}/bin/nft flush ruleset";
      };
    };
  };
}
