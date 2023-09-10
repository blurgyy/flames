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
  };

  config = mkIf cfg.enable {
    systemd.services.curltimesync = {
      path = with pkgs; [
        curl
        coreutils-full  # date
        gnugrep  # grep
        gnused  # sed
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        date -s "$(curl -s --head ${cfg.url} | grep '^Date:' | sed -Ee 's/Date: //g')"
      '';
    };
    systemd.timers.curltimesync-trigger = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60s";
        OnUnitInactiveSec = "180s";
        Persistent = true;
        Unit = "curltimesync.service";
      };
    };
  };
}
