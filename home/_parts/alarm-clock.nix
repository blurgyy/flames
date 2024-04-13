{ lib, pkgs, ... }: {
  # the alarms are saved in dconf, use
  #
  #   dconf dump /
  #
  # to inspect them.
  # Home-manager supports declarative configuration for dconf, but as alarm clock configurations are
  # volatile and mostly machine-specific, I will not declare them here.
  systemd.user.services.alarm-clock-applet = {
    Service = {
      Environment = [
        # REF:
        #   <https://github.com/alarm-clock-applet/alarm-clock/issues/210>
        #   <https://stackoverflow.com/questions/2120444/gstreamer-plugin-search-path>
        "GST_PLUGIN_PATH=${pkgs.gst_all_1.gst-plugins-base}"
        "PATH=${lib.makeBinPath [
          # "/run/current-system/sw/bin"
          pkgs.bash  # for the executable "sh"
          pkgs.pulseaudio  # pactl, for set volume and unmute
          pkgs.mpv  # mpv, for playing given 
          # a command that works:
          #
          #   sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ 100%; mpv --loop-file=inf /run/current-system/sw/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga'
        ]}"
      ];
      ExecStart = ''
        ${pkgs.alarm-clock-applet}/bin/alarm-clock-applet --hidden
      '';
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
