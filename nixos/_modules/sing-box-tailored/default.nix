{ config, lib, ... }:

with lib;

let
  cfg = config.services.sing-box;
  tunCidr = "169.254.169.0/31";
  tunDnsAddress = "169.254.169.1";
in

{
  options.services.sing-box = {
    preConfigure = mkEnableOption "Enable a set of predefined configs";
    tunInterface = mkOption {
      type = types.str;
      default = "singboxtun0";
    };
    needProxyForZju = mkOption {
      type = types.bool;
      default = null;
      description = "Determines which route to use for ZJU internal networks";
    };
  };

  config = mkIf cfg.preConfigure {
    services.resolved.enable = false;
    networking.resolvconf.extraConfig = ''
      name_servers=${tunDnsAddress}
    '';
    systemd.network.networks."50-sing-box" = {  # Configs adapted from /etc/systemd/network/50-tailscale.network
      matchConfig.Name = cfg.tunInterface;
      linkConfig = {  
        ActivationPolicy = "manual";
        Unmanaged = true;
      };
    };

    services.sing-box.settings = import ./settings.nix {
      inherit config lib cfg tunCidr;
    };

    systemd.services.sing-box.serviceConfig.LogNamespace = "noisy";
  };
}
