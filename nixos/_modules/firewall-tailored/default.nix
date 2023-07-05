{ config, lib, pkgs, ... }: with lib; let
  cfg = config.networking.firewall-tailored;
  portType = with types; oneOf [ int str ];
  comment = mkOption { type = types.nullOr types.str; default = null; };
  countPackets = mkOption { type = types.bool; default = true; };
  portModule = types.submodule ({ ... }: {
    options = {
      inherit comment countPackets;
      port = mkOption { type = portType; };
      protocols = mkOption { type = types.listOf types.str; };
      predicate = mkOption { type = types.nullOr types.str; default = null; };
    };
  });
  AddrGroupModule = types.submodule ({ ... }: {
    options = {
      inherit comment countPackets;
      addrs = mkOption { type = types.listOf types.str; };
    };
  });
in {
  options.networking.firewall-tailored = {
    enable = mkEnableOption "Tailored firewall module";

    acceptedPorts = mkOption { type = types.listOf (types.oneOf [ portType portModule ]); default = []; };
    rejectedPorts = mkOption { type = types.listOf (types.oneOf [ portType portModule ]); default = []; };
    acceptedAddrGroups = mkOption { type = types.listOf AddrGroupModule; default = []; };
    rejectedAddrGroups = mkOption { type = types.listOf AddrGroupModule; default = []; };

    extraRulesAfter = mkOption { type = types.listOf types.lines; default = []; };
    extraInputRules = mkOption { type = types.listOf types.lines; default = []; };
    extraForwardRules = mkOption { type = types.listOf types.lines; default = []; };
    extraOutputRules = mkOption { type = types.listOf types.lines; default = []; };

    referredServices = mkOption {
      type = types.listOf types.str;
      description = ''
        System services to be reloaded, these services are also added to the Wants= dependencies of
        nftables.service.
      '';
    };
  };

  config = mkIf cfg.enable {
    warnings = with builtins; let
        getCyclingServices = services:
          filter
            (name:
              elem
                "network.target"
                (if hasSuffix ".target" name
                  then config.systemd.targets.${removeSuffix ".target" name}.after
                  else config.systemd.services.${removeSuffix ".service" name}.after)
            )
            services;
        mkWarnings = services:
          map
            (svcName: ''
              firewall-tailored: SYSTEMD SERVICES ORDERING CYCLE DETECTED

              `${svcName}` here shouldn't use "After=network.target", because nftables by default is
              ordered **before** network-pre.target, which is in turn ordered **before**
              network.target.  By setting "Before=nftables.service" for the service in the
              firewall-tailored module (because `${svcName}` has been added to
              `config.networking.firewall-tailored.referredServices` somewhere), it's an ordering
              cycle.

              The cycle:
                nftables.service ↴
                ^ network-pre.target ↴
                |   network.target ↴
                |     ${svcName} ↴ 
                nftables.service
            '')
            (getCyclingServices services);
      in mkWarnings cfg.referredServices;

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
  10.0.0.0/8,
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

    meta l4proto icmp accept comment "allow icmp"
    meta l4proto ipv6-icmp accept comment "allow icmp v6"

    # Rejected address groups
    ${concatStringsSep "\n    " (map (addrGroup:
      "ip saddr {${concatStringsSep "," addrGroup.addrs}} ${
        optionalString addrGroup.countPackets "counter"
      } drop ${
        optionalString (addrGroup.comment != null) "comment \"${addrGroup.comment}\""
      }")
      cfg.rejectedAddrGroups)}

    # Accepted address groups
    ${concatStringsSep "\n    " (map (addrGroup:
      "ip saddr {${concatStringsSep "," addrGroup.addrs}} ${
        optionalString addrGroup.countPackets "counter"
      } accept ${
        optionalString (addrGroup.comment != null) "comment \"${addrGroup.comment}\""
      }")
      cfg.acceptedAddrGroups)}

    # Rejected ports
    ${concatStringsSep "\n    " (map (portInfo: with builtins;
    if (((typeOf portInfo) == "int") || ((typeOf portInfo) == "string"))
      then "meta l4proto tcp th dport ${toString portInfo} drop"
      else "${
        optionalString (portInfo.predicate != null) portInfo.predicate
      } meta l4proto {${concatStringsSep "," portInfo.protocols}} th dport ${toString portInfo.port} ${
        optionalString portInfo.countPackets "counter"
      } drop ${
        optionalString (portInfo.comment != null) "comment \"${portInfo.comment}\""
      }"
    )
    cfg.rejectedPorts)}

    # Accepted ports
    ${concatStringsSep "\n    " (map (portInfo: with builtins;
    if (((typeOf portInfo) == "int") || ((typeOf portInfo) == "string"))
      then "meta l4proto tcp th dport ${toString portInfo} accept"
      else "${
        optionalString (portInfo.predicate != null) portInfo.predicate
      } meta l4proto {${concatStringsSep "," portInfo.protocols}} th dport ${toString portInfo.port} ${
        optionalString portInfo.countPackets "counter"
      } accept ${
        optionalString (portInfo.comment != null) "comment \"${portInfo.comment}\""
      }"
    )
    cfg.acceptedPorts)}

    pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    ${concatStringsSep "\n" cfg.extraInputRules}
    counter
  }
  chain forward {
    type filter hook forward priority filter
    policy drop
    ${concatStringsSep "\n" cfg.extraForwardRules}
    counter
  }
  chain output {
    type filter hook output priority filter
    policy accept
    ${concatStringsSep "\n" cfg.extraOutputRules}
    counter
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
          # WARN:
          #   The service (with name=${name}) here also shouldn't use "After=network.target",
          #   because nftables by default is ordered **before** network-pre.target, which is ordered
          #   **before** network.target.  By setting "Before=nftables.service" for the service, it's
          #   an ordering cycle (i.e. nftables.service -> network-pre.target -> network.target ->
          #   ${name}.service -> nftables.service).
        };
      })
      cfg.referredServices
    ));
  };
}
