{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.v2ray-tailored;
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
      remotes = mkOption { type = with types; listOf attrs; };
    };
    server = {
      enable = mkEnableOption "Tailored V2Ray service (as server)";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.v2ray-loyalsoldier;
    };
  };
  config = mkIf (cfg.client.enable || cfg.server.enable) {
    # Avoid collision with original v2ray service
    services.v2ray.enable = false;

    # As client
    sops.templates = {
      vclient-config.content = with cfg.client; mkIf cfg.client.enable (builtins.toJSON
        (import ./client {
          inherit config lib uuid extraHosts soMark fwMark ports remotes;
        }));
    };
    sops.templates.nftables.content = mkIf cfg.client.enable config.networking.nftables.ruleset;
    networking.nftables = mkIf cfg.client.enable {
      enable = true;
      rulesetFile = config.sops.templates.nftables.path;
      ruleset = with builtins; with cfg.client; mkAfter ''
define proxy_bypassed_IPs = {
  100.64.0.0/10,
  127.0.0.0/8,
  169.254.0.0/16,
  172.16.0.0/12,
  192.168.0.0/16,
  224.0.0.0/4,
  240.0.0.0/4,
  255.255.255.255/32,
  ${concatStringsSep "," (map (x: x.address) (filter (x: x.wsPath == null) remotes))}
}
table ip transparent_proxy
delete table ip transparent_proxy
table ip transparent_proxy {
  chain prerouting {
    type filter hook prerouting priority mangle
    policy accept

    iifname != "lo" return

    ip daddr $proxy_bypassed_IPs return

    meta l4proto {tcp, udp} socket transparent 1 meta mark ${toString fwMark} return
    meta l4proto {tcp, udp} socket transparent 1 meta mark ${toString soMark} return
    meta l4proto {tcp, udp} meta mark ${toString fwMark} tproxy to :${toString ports.tproxy}
  }

  chain output {
    type route hook output priority mangle
    policy accept

    ip daddr $proxy_bypassed_IPs return

    socket cgroupv2 level 1 "system.slice" socket cgroupv2 level 2 != "system.slice/nix-daemon.service" return
    meta l4proto {tcp, udp} meta mark set ${toString fwMark} 
  }
}'';
    };
    systemd.services.vclient = mkIf cfg.client.enable {
      description = "V2Ray client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/v2ray -config ${config.sops.templates.vclient-config.path}";
        LimitNOFILE = 1000000007;
      };
    };
    networking.resolvconf.extraConfig = mkIf cfg.client.enable "name_servers=127.0.0.53";  # REF: man:resolvconf.conf(5)
    services.resolved.enable = mkIf cfg.client.enable false;
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

    # TODO: As server
  };
}
