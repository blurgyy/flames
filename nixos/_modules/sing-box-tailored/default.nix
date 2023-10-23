{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sing-box;
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
    tunAddress = mkOption {
      type = types.str;
      default = "169.254.169.0/31";
    };
    tunDnsAddress = mkOption {
      type = types.str;
      default = "169.254.169.1";
      description = ''
        DNS written to `/etc/resolvconf.conf`, which is subsequently written to `/etc/resolv.conf`.
        Should be within the IP-CIDR range of `tunAddress`, and does not equal `tunAddress`.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.preConfigure {  # generate settings
      services.sing-box.settings = import ./settings.nix {
        inherit config lib cfg;
        inherit (cfg) tunAddress;
      };
    })

    (mkIf cfg.enable {
      services.resolved.enable = false;
      networking.resolvconf.extraConfig = ''
        name_servers=${cfg.tunDnsAddress}
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
        after = lib.optional config.networking.useNetworkd "systemd-networkd.service";
        # restart on systemd-networkd restart
        bindsTo = lib.optional config.networking.useNetworkd "systemd-networkd.service";
        # restart on systemd-networkd reload (nixos activation only restarts this service when these
        # files' path change)
        restartTriggers = config.systemd.services.systemd-networkd.reloadTriggers;
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
