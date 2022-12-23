{ config, pkgs, callWithHelpers }: {
  enable = true;
  package = pkgs.waybar-hyprland;
  settings = callWithHelpers ./settings.nix {};
  style = callWithHelpers ./style.css.nix {};
  systemd = {
    enable = true;
    target = "sway-session.target";
  };
}
