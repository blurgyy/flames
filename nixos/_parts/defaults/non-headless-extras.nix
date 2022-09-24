{ lib, pkgs, ... }: rec {
  boot.initrd.kernelModules = [ "i915" "amdgpu" ];

  programs = {
    light.enable = lib.mkDefault true;
  };

  hardware = {
    bluetooth.enable = lib.mkDefault true;
    opengl = {
      # NOTE: needed to get sway to work.  (See https://search.nixos.org)
      enable = lib.mkDefault true;
      extraPackages = with pkgs; [ vaapiIntel ];
    };
  };

  # Enable pipewire (see NixOS Wiki)
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
    wireplumber.enable = lib.mkDefault true;
    media-session.enable = lib.mkDefault false;
  };

  # Needed for swaylock to work
  security.pam.services.swaylock = { };

  i18n.inputMethod = {
    enabled = "fcitx5";  # Needed for fcitx5 to work in qt6
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-lua
      libsForQt5.fcitx5-qt
      fcitx5-sogou-themes
      fcitx5-fluent-dark-theme
    ];
  };

  xdg.portal = {
    enable = lib.mkDefault true;
    wlr.enable = lib.mkDefault true;
    #gtkUsePortal = true;  # It's deprecated (for some reason, enable this and see trace message while rebuilding)
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];  # needed for opening filechooser
  };
}
