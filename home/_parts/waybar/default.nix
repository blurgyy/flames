{ config, pkgs, callWithHelpers }: {
  enable = true;
  settings = callWithHelpers ./settings.nix {};
  style = callWithHelpers ./style.css.nix {};
  systemd = {
    enable = true;
    target = "sway-session.target";
  };
}
