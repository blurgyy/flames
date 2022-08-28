{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.v2ray-tailored;
  remoteModule = types.submodule ({ ... }: {
    options = {
      tag = mkOption { type = types.str; };
      address = mkOption { type = types.str; };
      port = mkOption { type = with types; oneOf [ str int ]; };
      domain = mkOption { type = types.str; };
      wsPath = mkOption { type = types.nullOr types.str; default = null; };
      allowInsecure = mkOption { type = types.bool; default = false; };
    };
  });
  userModule = types.submodule ({ ... }: {
    options.uuid = mkOption { type = types.str; example = "44444444-4444-4444-8888-888888888888"; };
    options.email = mkOption { type = types.str; example = "example@example.org"; };
    options.level = mkOption { type = types.int; example = 0; };
  });
  reverseModule = types.submodule ({ ... }: {
    options = {
      counterpartName = mkOption { type = types.str; };
      position = mkOption { type = types.enum [ "world" "internal" ]; };
      port = mkOption { type = with types; oneOf [ str int ]; };
      id = mkOption { type = types.str; example = "44444444-4444-4444-8888-888888888888"; };
      proxiedDomains = mkOption { type = types.listOf types.str; default = []; };  # Works when position is "world"
      proxiedIPs = mkOption { type = types.listOf types.str; default = []; };  # Works when position is "world"
      counterpartAddr = mkOption { type = types.str; example = "1.1.1.1"; };  # Works when position is "internal"
    };
  });
in {
  options.services.v2ray-tailored = {
    client = {
      enable = mkEnableOption "Tailored V2Ray service (as client)";
      uuid = mkOption { type = types.str; };
      extraHosts = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra entries to check before querying DNS";
      };
      soMark = mkOption { type = with types; oneOf [ str int ]; };
      fwMark = mkOption { type = with types; oneOf [ str int ]; };
      ports.http = mkOption { type = with types; oneOf [ str int ]; };
      ports.socks = mkOption { type = with types; oneOf [ str int ]; };
      ports.tproxy = mkOption { type = with types; oneOf [ str int ]; };
      remotes = mkOption { type = with types; listOf remoteModule; };
      overseaSelectors = mkOption { type = types.listOf types.str; };
      proxiedSystemServices = mkOption { type = types.listOf types.str; default = [ "nix-daemon.service" ]; };
    };
    server = {
      enable = mkEnableOption "Tailored V2Ray service (as server)";
      ports.api = mkOption { type = with types; oneOf [ str int ]; };
      ports.tcp = mkOption { type = with types; oneOf [ str int ]; };
      ports.wss = mkOption { type = with types; oneOf [ str int ]; };
      wsPath = mkOption { type = types.str; description = "Path for websocket inbound"; };
      usersInfo = mkOption {
        type = with types; listOf userModule;
        default = [ ];
        description = "Credentials of users to serve";
      };
      reverse = mkOption { type = types.nullOr reverseModule; default = null; };
    };
    package = mkOption {
      type = types.package;
      default = pkgs.v2ray-loyalsoldier;
    };
  };
  config = let
    commonServiceConfig = {
      User = config.users.users.v2ray.name;
      Group = config.users.groups.v2ray.name;
      LogsDirectory = "v2ray";
      LogsDirectoryMode = "0700";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" "CAP_NET_RAW" ];
      LimitNOFILE = 1000000007;
    };
  in mkIf (cfg.client.enable || cfg.server.enable) {
    # Avoid collision with original v2ray service
    services.v2ray.enable = false;

    users.users.v2ray = {
      group = config.users.groups.v2ray.name;
      isSystemUser = true;
    };
    users.groups.v2ray = {};

    # As client
    sops.templates.vclient-config = with cfg.client; mkIf enable {
      content = builtins.toJSON (import ./client { inherit config lib uuid extraHosts soMark fwMark ports remotes overseaSelectors; });
      owner = config.users.users.v2ray.name;
      group = config.users.groups.v2ray.name;
    };
    networking.firewall-tailored = mkIf (cfg.client.enable || cfg.server.reverse != null) {
      enable = true;
      acceptedPorts = (if cfg.client.enable then [{
        port = 9990;
        protocols = [ "tcp" ];
        comment = "allow machines from private network ranges to access http proxy";
        predicate = "ip saddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 }";
      }] else []) ++ (if cfg.server.reverse != null then [{
        port = cfg.server.reverse.port;
        protocols = [ "tcp" ];
        comment = "allow traffic on V2Ray reverse proxy control channel";
      }] else []);
      referredServices = cfg.client.proxiedSystemServices;
      extraRulesAfter = with builtins; with cfg.client; [''
include "${pkgs.nftables-geoip-db}/share/nftables-geoip-db/CN.ipv4"
define proxy_bypassed_IPs = {
  100.64.0.0/10,
  127.0.0.0/8,
  169.254.0.0/16,
  172.16.0.0/12,
  192.168.0.0/16,
  224.0.0.0/4,
  240.0.0.0/4,
  255.255.255.255/32,
  ${concatStringsSep "," ((map (x: toString x.address) (filter (x: x.wsPath == null) remotes))
    ++ (if (cfg.server.reverse != null) then [ (toString cfg.server.reverse.port) ] else []))}
}
table ip transparent_proxy
delete table ip transparent_proxy
table ip transparent_proxy {
  chain prerouting {
    type filter hook prerouting priority mangle
    policy accept

    iifname != "lo" return

    ip daddr $proxy_bypassed_IPs return

    meta l4proto {tcp,udp} socket transparent 1 meta mark ${toString fwMark} return
    meta l4proto {tcp,udp} socket transparent 1 meta mark ${toString soMark} return
    meta l4proto {tcp,udp} meta mark ${toString fwMark} tproxy to :${toString ports.tproxy}
  }

  chain output {
    type route hook output priority mangle
    policy accept

    ip daddr $proxy_bypassed_IPs return
    ip daddr $geoip4_iso_country_CN return

    socket cgroupv2 level 1 "system.slice" ${optionalString
      ((length cfg.client.proxiedSystemServices) > 0)
      (concatStringsSep " " (map
        (svc: ''socket cgroupv2 level 2 != "system.slice/${svc}"'')
        cfg.client.proxiedSystemServices
        )
      )
    } return
    meta l4proto {tcp,udp} meta mark set ${toString fwMark} 
  }
}''];
    };
    systemd.services.vclient = mkIf cfg.client.enable {
      description = "V2Ray client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/v2ray -config ${config.sops.templates.vclient-config.path}";
      };
      restartTriggers = [ config.sops.templates.vclient-config.content ];
    };
    networking.resolvconf.extraConfig = mkIf cfg.client.enable "name_servers=127.0.0.53";  # REF: man:resolvconf.conf(5)
    services.resolved.enable = mkIf cfg.client.enable (mkForce false);
    systemd.services.nftables.requires = mkIf cfg.client.enable [ "nix-daemon.service" ];
    systemd.network = mkIf cfg.client.enable {
      config.routeTables = { v2ray-tproxy = 10007; };
      networks.tproxyroutes = {
        name = "*";
        routes = [
          {
            routeConfig = {
              Destination = "0.0.0.0/0";
              Table = "v2ray-tproxy";
              Scope = "host";
              Type = "local";
            };
          }
        ];
        routingPolicyRules = [
          {
            routingPolicyRuleConfig = {
              FirewallMark = cfg.client.fwMark;
              Table = "v2ray-tproxy";
            };
          }
          {
            routingPolicyRuleConfig = {
              From = "lo";
              Table = "v2ray-tproxy";
            };
          }
        ];
      };
    };

    # As server
    sops.templates.vserver-config = with cfg.server; mkIf enable {
      content = builtins.toJSON (import ./server { inherit config lib usersInfo ports wsPath reverse; });
      owner = config.users.users.v2ray.name;
      group = config.users.groups.v2ray.name;
    };
    systemd.services.vserver = mkIf cfg.server.enable {
      description = "V2Ray server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/v2ray -config ${config.sops.templates.vserver-config.path}";
      };
      restartTriggers = [ config.sops.templates.vserver-config.content ];
    };
  };
}
