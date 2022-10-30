{ config, lib, pkgs, ... }: with lib; let
  cfg = config.networking.firewall-tailored;
  portType = with types; oneOf [ int str ];
  portModule = types.submodule ({ ... }: {
    options.port = mkOption { type = portType; };
    options.protocols = mkOption { type = types.listOf types.str; };
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
    referredServices = mkOption {
      type = types.listOf types.str;
      description = ''
        System services to be reloaded, these services are also added to the Wants= dependencies of
        nftables.service.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = config.networking.firewall.enable == false;
      message = "nftables is not meant to be used with iptables.  `networking.firewall.enable` must be set to false.";
    } {
      assertion = config.networking.nftables.enable == false;
      message = "`networking.firewall-tailored` conflicts with `networking.nftables`.  `networking.nftables` must be set to false.";
    } {
      assertion = builtins.all (svc: hasSuffix ".service" svc) cfg.referredServices;
      message = "Service names in `networking.firewall-tailored.referredServices` must end with \".service\"";
    }];
    networking.firewall.enable = false;
    networking.nftables.enable = false;
    boot.blacklistedKernelModules = [ "ip_tables" ];
    environment.systemPackages = [ pkgs.nftables ];
    sops.templates.nftables-rules = {
      name = "nftables.conf";
      content = ''
flush ruleset

define private_range = {
  100.64.0.0/10,
  127.0.0.0/8,
  169.254.0.0/16,
  172.16.0.0/12,
  192.168.0.0/16,
  224.0.0.0/4,
  240.0.0.0/4,
  255.255.255.255/32,
}

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
      then "meta l4proto tcp th dport ${toString portInfo} accept"
      else "${if (portInfo.predicate != null)
          then portInfo.predicate
          else ""
        } meta l4proto {${concatStringsSep "," portInfo.protocols}} th dport ${toString portInfo.port} accept ${if (portInfo.comment != null)
          then "comment \"${portInfo.comment}\""
          else ""
        }"
      )
    cfg.acceptedPorts)}

    pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    counter
  }
  chain forward {
    type filter hook forward priority filter
    policy drop
  }
}

${concatStringsSep "\n" cfg.extraRulesAfter}
      '';
    };
    systemd.services = {
      nftables = let
        ruleFile = config.sops.templates.nftables-rules;
      in {
        description = "nftables firewall";
        before = [ "network-pre.target" ];
        wants = [ "network-pre.target" ];
        wantedBy = [ "multi-user.target" ];
        reloadIfChanged = true;
        restartTriggers = [ (builtins.hashString "sha512" ruleFile.content) ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.nftables}/bin/nft -f ${ruleFile.path}";
          ExecReload = "${pkgs.nftables}/bin/nft -f ${ruleFile.path}";
          ExecStop = "${pkgs.nftables}/bin/nft flush ruleset";
        };
      };
    } // (foldl' mergeAttrs {} (map
      (svc: let
        name = removeSuffix ".service" svc;
      in {
        ${name} = {
          wants = [ "nftables.service" ];  # svc is referred, so add a dependency on firewall in case it does not work without a firewall.
          before = [ "nftables.service" ];  # svc's cgroupv2 path needs to be present at the time firewall tries to start.
        };
      })
      cfg.referredServices
    ));
  };
}
