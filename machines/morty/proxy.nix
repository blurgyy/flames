{ config, lib, pkgs, ... }: {
  systemd.services.nftables.requires = [ "nix-daemon.service" ];
  systemd.services.v2ray.serviceConfig.LimitNOFILE = 1000000007;
  networking.resolvconf.extraConfig = "name_servers=127.0.0.53";  # REF: man:resolvconf.conf(5)
  networking.nftables = {
    enable = true;
    rulesetFile = config.sops.templates.nftables.path;
  };
  systemd.network = {
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
            FirewallMark = 39283;
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
  services.v2ray = {
    enable = true;
    package = pkgs.v2ray-loyalsoldier;
    configFile = config.sops.templates.v2ray-config.path;
  };

  services.rathole = {
    enable = true;
    configFile = config.sops.templates.rathole-config.path;
  };

  sops.templates.v2ray-config.content = builtins.toJSON (import ./parts/v2ray { inherit lib config; });
  sops.templates.rathole-config.content = pkgs.toTOML (import ./parts/rathole.nix { inherit config; });
  sops.templates.nftables.content = import ./parts/nftables.conf.nix { inherit config; };
}
