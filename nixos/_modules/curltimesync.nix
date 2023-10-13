{ config, lib, pkgs, ... }:

let
  cfg = config.services.curltimesync;
in

with lib;

{
  options.services.curltimesync = {
    enable = mkEnableOption "Whether to enable home-made time synchronizer via curl";
    url = mkOption {
      type = types.str;
      description = "An (almost) always-online website to request using curl";
      example = "google.com";
    };
    intervalSec = mkOption {
      type = types.int;
      description = "Check for time update this many seconds";
      default = 30;
    };
    toleranceSec = mkOption {
      type = types.int;
      description = ''
        If the difference between requested network time and local time is larger than this
        threshold (in seconds), update local time to match network time.  This is to avoid tiny
        perturbations of network time that make systemd-journald think time jumped backwards.
      '';
      default = 3;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.curltimesync = {
      path = with pkgs; [
        curl
        coreutils-full  # date
        gnugrep  # grep
        gnused  # sed
        bc  # bc
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        # abort if curl failed to request header in while condition
        set -eo pipefail

        while ! resp="$(curl -fsSI ${cfg.url} | grep '^Date:' | sed -Ee 's/Date: //g')"; do
          >&2 echo "curl failed, retrying after 1s"
          sleep 1
        done

        net_time="$(date --date="$resp" +%s)"

        local_time=$(date +%s)

        # absolute time difference
        diff="$(echo $(( net_time - local_time )) | sed -Ee 's/-//g')"

        if [[ "$diff" -gt ${toString cfg.toleranceSec} ]]; then
          date --set="$(date --date=@"$net_time")"
        fi
      '';
    };
    systemd.timers.curltimesync-trigger = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "${toString (cfg.intervalSec / 3)}s";
        OnUnitInactiveSec = "${toString cfg.intervalSec}s";
        Persistent = true;
        Unit = "curltimesync.service";
      };
    };
  };
}
