{ interfaces, pkgs, lib }:

let
  mkScriptFor = iface: pkgs.writeScript "restart-sing-box-on-${iface}-wireless-reconnect" ''
    # Initial timestamp, 0 means not set
    LAST_TIMESTAMP=0

    while true; do
        # Get the latest timestamp for CTRL-EVENT-CONNECTED from journalctl
        NEW_TIMESTAMP=$(journalctl -u wpa_supplicant-${iface}.service --since "1 hour ago" | grep "CTRL-EVENT-CONNECTED" | tail -1 | awk '{print $1 " " $2 " " $3}')

        # echo new timestamp: $NEW_TIMESTAMP

        if [ -n "$NEW_TIMESTAMP" ]; then
            # Convert timestamp to seconds since epoch
            NEW_TIMESTAMP_SEC=$(date -d "$NEW_TIMESTAMP" +%s)
            if [[ "$LAST_TIMESTAMP" != 0 && "$NEW_TIMESTAMP_SEC" -gt "$LAST_TIMESTAMP" ]]; then
                echo "Network reconnection detected. Restarting Sing-box."
                systemctl restart sing-box.service
            fi
            LAST_TIMESTAMP=$NEW_TIMESTAMP_SEC
        fi
        sleep 3  # Check every 3 seconds
    done
  '';

  systemdServicesForRestarting = lib.genAttrs interfaces (iface: {
    description = "Monitor ${iface} and restart Sing-box on reconnection";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    script = mkScriptFor iface;
    serviceConfig = {
      Restart = "always";
      User = "root";
    };
  });

in

builtins.mapAttrs
  (name: value: {
    name = "restart-sing-box-on-${name}-wireless-reconnect";
    inherit value;
  })
  systemdServicesForRestarting
