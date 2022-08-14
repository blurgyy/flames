# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        # A lot GUI programs need this, nearly all wayland applications
        "cma=128M"
    ];
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree = {
    enable = true;
    filter = "bcm2711-rpi-4-b.dtb";  # WARN: Using the default value `bcm2711-rpi-*.dtb` here will cause dtoverlay fail to apply to bcm2711-rpi-cm4.dtb
    overlays = [  # REF: https://github.com/raspberrypi/linux
      { name = "gpio-ir"; dtsFile = ./device-tree/gpio-ir.dts; }
      { name = "gpio-ir-tx"; dtsFile = ./device-tree/gpio-ir-tx.dts; }
    ];
  };

  nix = {
    package = pkgs.nixStable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  users = let
    keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKco1z3uNTuYW7eVl2MTPrvVG5jnEnNJne/Us+LhKOwC gy@rpi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4yanex/42s/F9dP7CJ3BstzEC7n0qwi0+2hhxOAS6 gy@hooper"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdK4KWp4YMiDfq+hLZ3fQQ+02XnYhLY47l7Zro+xKud gy@watson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYfrTPDWGRcxfnmDU88HLoDrWekz+yTZHk68/75FtDX gy@Blurgy"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlMIWDojT8L4g7g0z6uC2EhALHr2fL/ZIdNnNiyggBj gy@HUAWEI"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1LWYTkOiaY/TSs9qoAAQm2tVHw4Lljz90pCREnW2Zx gy@FridaY"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlA0ON/HBEhGPo1Uu5lrgpbQ/D/Ivd7q3LuNTXScrRi gy@john"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1m/+k7RnoL1YVbP4vv8XTFnlP6CGmnXJfxA+Xu6H5q gy@morty"
      ];
  in {
    users.root.openssh.authorizedKeys.keys = keys;
    mutableUsers = false;
    groups.plocate = {};
  };

  networking = {
    useDHCP = false;
    hostName = "rpi";
    useNetworkd = true;
    interfaces.wlan0.useDHCP = true;  # `interfaces."*".useDHCP` is buggy
    wireless = {
      enable = true;
      networks = { };  # See ./sops.nix
    };
    firewall.enable = false;
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=16s";
    network.wait-online = {
      anyInterface = true;
      timeout = 16;
    };
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    openssh.enable = true;
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };
  services.acremote.enable = true;

  security.sudo.extraRules = let
    applyNoPasswd = cmd: { command = cmd; options = [ "NOPASSWD" ]; };
    systemdCmds = map applyNoPasswd (map (cmd: "${pkgs.systemd}/bin/${cmd}") [ "systemctl" "journalctl" ]);
  in [
    { groups = [ "wheel" ]; commands = systemdCmds; }
  ];

  environment.systemPackages = with pkgs; [
    v4l-utils  # for `ir-ctl` executable
    git
    ffmpeg
    lsof
    libnotify
    miniserve
    procs
    transmission
    neovim
    zsh fish fzf
    htop
    file
    zip unzip unar
    plocate
    jq
    #libqalculate  # build fails
    sops age
    hydra-check
  ];

  documentation.nixos.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
