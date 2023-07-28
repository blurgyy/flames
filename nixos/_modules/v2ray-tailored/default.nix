{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.v2ray-tailored;
in {
  options.services.v2ray-tailored = let
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
    loggingModule = types.submodule ({ ... }: {
      options.level = mkOption {
        type = types.enum [ "debug" "info" "warning" "error" "none" ];
        default = "warning";
      };
      options.access = mkOption {
        type = with types; nullOr (oneOf [ bool str ]);
        description = ''
          Whether to write access log, by default, this is enabled for client but disabled for
          server.
        '';
        default = null;
      };
      options.error = mkOption {
        type = with types; oneOf [ bool str ];
        description = "Whether to write error log, this is enabled by default";
        default = true;
      };
    });
  in {
    client = {
      enable = mkEnableOption "Tailored V2Ray service (as client)";
      logging = mkOption { type = loggingModule; default = {}; };
      uuid = mkOption { type = types.str; };
      extraHosts = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra entries to check before querying DNS";
      };
      disabledRoutingRules = mkOption {
        type = with types; listOf str;
        description = ''
          Any routing rule file that has the same basename as one of these will be ignored.
        '';
        example = [ "20-random-cn-server-ip" ];
        default = [];
      };
      soMark = mkOption { type = with types; oneOf [ str int ]; };
      fwMark = mkOption { type = with types; oneOf [ str int ]; };
      ports.http = mkOption { type = with types; oneOf [ str int ]; };
      ports.socks = mkOption { type = with types; oneOf [ str int ]; };
      ports.tproxy = mkOption { type = with types; oneOf [ str int ]; };
      remotes = mkOption { type = with types; listOf remoteModule; };
      transparentProxying = {
        enable = mkEnableOption "Whether to set extra firewall rules to enable transparent proxying";
        bypassedIPs = mkOption { type = types.listOf types.str; default = []; };
        proxiedSystemServices = mkOption { type = types.listOf types.str; default = [ "nix-daemon.service" ]; };
      };
    };
    server = {
      enable = mkEnableOption "Tailored V2Ray service (as server)";
      logging = mkOption { type = loggingModule; default = {}; };
      ports.http = mkOption { type = with types; oneOf [ str int ]; };
      ports.socks = mkOption { type = with types; oneOf [ str int ]; };
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
  in mkIf (cfg.client.enable || cfg.server.enable || cfg.server.reverse != null) {
    # Avoid collision with original v2ray service
    services.v2ray.enable = false;
    environment.systemPackages = [ cfg.package ];

    users = {
      users.v2ray = {
        group = config.users.groups.v2ray.name;
        isSystemUser = true;
      };
      groups.v2ray = {};
    };

    # As client
    sops.templates.vclient-config = with cfg.client; mkIf enable {
      name = "vclient.json";
      content = builtins.toJSON (import ./client { inherit config lib uuid logging extraHosts disabledRoutingRules soMark fwMark ports remotes; });
      owner = config.users.users.v2ray.name;
      group = config.users.groups.v2ray.name;
    };
    networking.firewall-tailored = mkMerge [
      # mkMerge[0]
      (mkIf (cfg.client.enable || cfg.server.enable || cfg.server.reverse != null) {
        enable = true;
        acceptedPorts = (lib.optional cfg.client.enable {
          port = cfg.client.ports.http;
          protocols = [ "tcp" ];
          comment = "allow machines from private network ranges to access http proxy (vclient)";
          predicate = "ip saddr $private_range";
        }) ++ (lib.optional cfg.client.enable {
              port = cfg.client.ports.socks;
              protocols = [ "tcp" ];
              comment = "allow machines from private network ranges to access socks proxy (vclient)";
              predicate = "ip saddr $private_range";
        }) ++ (lib.optional cfg.server.enable {
            port = cfg.server.ports.http;
            protocols = [ "tcp" ];
            comment = "allow machines from private network ranges to access http proxy (vserver)";
            predicate = "ip saddr $private_range";
        }) ++ (lib.optional cfg.server.enable {
              port = cfg.server.ports.socks;
              protocols = [ "tcp" ];
              comment = "allow machines from private network ranges to access socks proxy (vserver)";
              predicate = "ip saddr $private_range";
        }) ++ (lib.optional (cfg.server.reverse != null) {
            port = cfg.server.reverse.port;
            protocols = [ "tcp" ];
            comment = "allow traffic on V2Ray reverse proxy control channel";
        });
      })
      # mkMerge[1]
      (mkIf cfg.client.transparentProxying.enable {
        referredServices = mkIf cfg.client.enable cfg.client.transparentProxying.proxiedSystemServices;
        extraRulesAfter = with builtins; mkIf cfg.client.enable [''
          include "${pkgs.nftables-geoip-db}/share/nftables-geoip-db/CN.ipv4"
          define proxy_bypassed_IPs = {
            ${concatStringsSep "," (cfg.client.transparentProxying.bypassedIPs
              ++ (map (x: toString x.address) (filter (x: x.wsPath == null) cfg.client.remotes)))}
          }
          table ip transparent_proxy
          delete table ip transparent_proxy
          table ip transparent_proxy {
            chain prerouting {
              type filter hook prerouting priority mangle
              policy accept

              iifname != "lo" return

              ip daddr {
                $private_range,
                $proxy_bypassed_IPs,
              } return

              meta l4proto {tcp,udp} socket transparent 1 meta mark ${toString cfg.client.fwMark} return
              meta l4proto {tcp,udp} socket transparent 1 meta mark ${toString cfg.client.soMark} return
              meta l4proto {tcp,udp} meta mark ${toString cfg.client.fwMark} tproxy to :${toString cfg.client.ports.tproxy}
            }

            chain output {
              type route hook output priority mangle
              policy accept

              ip daddr {
                $private_range,
                $proxy_bypassed_IPs,
                $geoip4_iso_country_CN,
              } return

              socket cgroupv2 level 1 "system.slice" ${optionalString
                ((length cfg.client.transparentProxying.proxiedSystemServices) > 0)
                (concatStringsSep " " (map
                  (svc: ''socket cgroupv2 level 2 != "system.slice/${svc}"'')
                  cfg.client.transparentProxying.proxiedSystemServices
                  )
                )
              } return
              meta l4proto {tcp,udp} meta mark set ${toString cfg.client.fwMark} 
            }
          }
        ''];
      })
    ];  # end of mkMerge
    systemd.services.vclient = mkIf cfg.client.enable {
      description = "V2Ray client";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/v2ray run -c ${config.sops.templates.vclient-config.path}";
      };
      restartTriggers = [ (builtins.hashString "sha512" config.sops.templates.vclient-config.content) ];
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
      name = "vserver.json";
      content = builtins.toJSON (import ./server { inherit config lib logging usersInfo ports wsPath reverse; });
      owner = config.users.users.v2ray.name;
      group = config.users.groups.v2ray.name;
    };
    systemd.services.vserver = mkIf cfg.server.enable {
      description = "V2Ray server";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/v2ray run -c ${config.sops.templates.vserver-config.path}";
      };
      restartTriggers = [ (builtins.hashString "sha512" config.sops.templates.vserver-config.content) ];
    };
  };
}
