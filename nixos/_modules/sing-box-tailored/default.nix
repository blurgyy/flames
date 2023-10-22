{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sing-box;
  tunCidr = "169.254.169.0/31";
  tunDnsAddress = "169.254.169.1";
in

{
  options.services.sing-box = {
    preConfigure = mkEnableOption "Enable a set of predefined configs";
    secretPath = mkOption {
      type = types.str;
      description = "Path to the user secret for proxy server authentication";
    };
    tunInterface = mkOption {
      type = types.str;
      default = "singboxtun0";
    };
  };

  config = mkMerge [
    (mkIf cfg.preConfigure {  # generate settings
      services.sing-box.settings = import ./settings.nix {
        inherit config lib cfg;
        inherit tunCidr;
      };
    })

    (mkIf cfg.enable {
      services.resolved.enable = false;
      networking.resolvconf.extraConfig = ''
        name_servers=${tunDnsAddress}
      '';
      systemd.network.networks."50-sing-box" = {  # Configs adapted from /etc/systemd/network/50-tailscale.network
        matchConfig.Name = cfg.tunInterface;
        linkConfig.RequiredForOnline = false;
        linkConfig = {  
          ActivationPolicy = "manual";
          Unmanaged = true;
        };
      };
      systemd.services.sing-box = {
        bindsTo = [ "systemd-networkd.service" ];
        serviceConfig = {
          ExecStartPre = mkAfter [
            "${pkgs.proxy-rules}/bin/populate-sing-box-rules ${pkgs.proxy-rules}/src /etc/sing-box/config.json"
          ];
          LogNamespace = "noisy";
          MemoryAccounting = true;
          MemoryMax = "256M";
        };
      };
    })
  ];
}
