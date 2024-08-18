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
    graphics = {
      # NOTE: needed to get sway to work.  (See https://search.nixos.org)
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
      ];
    };
  };

  # Enable pipewire (see NixOS Wiki)
  security.rtkit.enable = lib.mkDefault true;
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;

    dbus.packages = [ pkgs.gcr ];  # gnome-keyring password prompt interface
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
