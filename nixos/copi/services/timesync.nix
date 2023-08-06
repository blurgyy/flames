{ pkgs, ... }: {
  systemd.services.timesync = {
    path = with pkgs; [
      curl
      coreutils-full  # date
      gnugrep  # grep
      gnused  # sed
    ];
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      date -s "$(curl -s --head baidu.com | grep '^Date:' | sed -Ee 's/Date: //g')"
    '';
  };

  systemd.timers.timesync-trigger = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "60s";
      OnUnitInactiveSec = "180s";
      Persistent = true;
      Unit = "timesync.service";
    };
  };
}
