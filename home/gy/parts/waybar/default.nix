{ pkgs, callWithHelpers }: {
  enable = true;
  package = pkgs.waybar-hyprland.overrideAttrs (o: {
    src = pkgs.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "master";
      sha256 = "sha256-sR7RAVCODYtQsQzL0lxs0SbH+yZiKvE/TApuDsYM/Bw=";
    };
  });
  settings = callWithHelpers ./settings.nix {};
  style = callWithHelpers ./style.css.nix {};
  systemd = {
    enable = true;
    target = "sway-session.target";
  };
}
