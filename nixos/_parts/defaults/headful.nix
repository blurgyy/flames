{ config, lib, pkgs, ... }: {
  boot = {
    initrd.kernelModules = [ "i915" "amdgpu" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
  };

  environment.systemPackages = with pkgs; [
    minicom
    swaylock-effects
    xdragon
  ];

  programs = {
    light.enable = lib.mkDefault true;
  };

  hardware = {
    bluetooth.enable = lib.mkDefault true;
    opengl = {
      # NOTE: needed to get sway to work.  (See https://search.nixos.org)
      enable = lib.mkDefault true;
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
      ];
    };
  };

  # Enable pipewire (see NixOS Wiki)
  security.rtkit.enable = lib.mkDefault true;
  services = {
    tumbler.enable = true;  # Thumbnail support in Thunar
    openssh.settings.StreamLocalBindUnlink = false;
    pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      jack.enable = lib.mkDefault true;
      wireplumber.enable = lib.mkDefault true;
    };
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
    config = {
      common = {
        # for flameshot to work
        # REF: <https://github.com/flameshot-org/flameshot/issues/3363#issuecomment-1753771427>
        default = "gtk";
        "org.freedesktop.impl.portal.Screencast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };
}
