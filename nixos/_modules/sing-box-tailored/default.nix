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
    restartOnWirelessReconnectInterfaces = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Restart sing-box on wpa_supplicant reconnect event from these interfaces";
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
            "${pkgs.proxy-rules}/bin/sing-box-rules populate ${pkgs.proxy-rules}/src /etc/sing-box/config.json"
          ];
          LogNamespace = "noisy";
          MemoryAccounting = true;
          MemoryMax = "256M";
        };
      };
    })

    (mkIf (cfg.restartOnWirelessReconnectInterfaces != []) (
      let
        mkScriptFor = iface: pkgs.writeShellScript "restart-sing-box-on-${iface}-wireless-reconnect" ''
          # Initial timestamp, 0 means not set
          LAST_TIMESTAMP=0

          log_every_n_checks=15
          n_checks=0

          while true; do
            n_checks=$((n_checks + 1))
            # Get the latest timestamp for CTRL-EVENT-CONNECTED from journalctl
            NEW_TIMESTAMP=$(journalctl -u wpa_supplicant-${iface}.service --since "1 hour ago" | grep "CTRL-EVENT-CONNECTED" | tail -1 | awk '{print $1 " " $2 " " $3}')

            if [ $n_checks -eq $log_every_n_checks ]; then
              echo "Last reconnection time: '$NEW_TIMESTAMP'"
              n_checks=0
            fi

            if [ -n "$NEW_TIMESTAMP" ]; then
              # Convert timestamp to seconds since epoch
              NEW_TIMESTAMP_SEC=$(date -d "$NEW_TIMESTAMP" +%s)
              if [[ "$LAST_TIMESTAMP" != 0 && "$NEW_TIMESTAMP_SEC" -gt "$LAST_TIMESTAMP" ]]; then
                  echo "Network reconnection detected. Restarting Sing-box."
                  systemctl restart sing-box.service
              fi
              LAST_TIMESTAMP=$NEW_TIMESTAMP_SEC
            fi
            sleep 2  # Check every 2 seconds
          done
        '';

        systemdServicesForRestarting = lib.genAttrs cfg.restartOnWirelessReconnectInterfaces (iface: {
          description = "Monitor ${iface} and restart Sing-box on reconnection";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.gawk ];
          serviceConfig = {
            ExecStart = mkScriptFor iface;
            Restart = "always";
            User = "root";
          };
        });

      in {
        systemd.services = lib.mapAttrs'
          (name: value: {
            name = "restart-sing-box-on-${name}-wireless-reconnect";
            inherit value;
          })
          systemdServicesForRestarting;
      }))
  ];
}
