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
      default = "10.169.169.169/30";
    };
    tunDnsAddress = mkOption {
      type = types.str;
      default = "255.255.255.254";
      description = ''
        DNS written to `/etc/resolvconf.conf`, which is subsequently written to `/etc/resolv.conf`.
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
      environment.systemPackages = [ pkgs.sing-box ];
      services.resolved.enable = false;
      networking.resolvconf.extraConfig = ''
        name_servers=${cfg.tunDnsAddress}
      '';
      systemd.network.networks."50-sing-box" = {  # Configs adapted from /etc/systemd/network/50-tailscale.network
        matchConfig.Name = cfg.tunInterface;
        linkConfig = {
          RequiredForOnline = false;
          ActivationPolicy = "manual";
          Unmanaged = true;
        };
      };
      systemd.services.sing-box = {
        after = lib.optional config.networking.useNetworkd "systemd-networkd.service";
        wantedBy = [ "nss-lookup.target" ];
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
