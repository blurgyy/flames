{ pkgs, ... }:

{
  systemd.user.services.ydotoold = {
    Unit = {
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.ydotool}/bin/ydotoold";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [
        "graphical-session.target"
        "sway-session.target"
        "hyprland-session.target"
      ];
    };
  };
}
