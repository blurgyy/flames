# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];

  #nixpkgs.localSystem = lib.systems.examples.gnu64;
  #nixpkgs.crossSystem.system = "aarch64-linux";
  #nixpkgs.crossSystem = lib.systems.examples.aarch64-multiplatform;

  boot = {
    supportedFilesystems = [ "btrfs" "ext4" ];
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernel = {
      sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "dev.i915.perf_stream_paranoid" = 0;
        "kernel.sysrq" = 1;
        "vm.swappiness" = 1;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 80;
      };
    };
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
    autoOptimiseStore = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "gy" ];
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
    groups = {
      plocate = {};
      infrared = {};
    };
    users.gy = {
      isNormalUser = true;
      extraGroups = [
        config.users.groups.wheel.name
        config.users.groups.video.name
        config.users.groups.plocate.name
        config.users.groups.infrared.name
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };
  };

  networking.proxy = {
    httpProxy = "http://192.168.0.114:9990";
    httpsProxy = "http://192.168.0.114:9990";
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
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=16s";
    network.wait-online = {
      anyInterface = true;
      timeout = 16;
    };
  };

  #systemd.services.acremote = {
  #  unitConfig = {
  #    Description = "Run acremote backend";
  #  };
  #  serviceConfig = {
  #    ExecStart = "${pkgs.acremote-backend}/bin/acremote-backend -l 12682 "; #-s ${pkgs.acremote-frontend}/share/webapp/acremote-frontend";
  #    Restart = "always";
  #    RestartSec = "3s";
  #  };
  #  wantedBy = [ "multi-user.target" ];
  #};

  services = {
    openssh.enable = true;
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
  };

  security.sudo.extraRules = let
    applyNoPasswd = cmd: { command = cmd; options = [ "NOPASSWD" ]; };
    infraredCtlCmds = map applyNoPasswd (map (cmd: "${pkgs.v4l-utils}/bin/${cmd}") [ "ir-ctl" ]);
    systemdCmds = map applyNoPasswd (map (cmd: "${pkgs.systemd}/bin/${cmd}") [ "systemctl" "journalctl" ]);
  in [
    { groups = [ "infrared" ]; commands = infraredCtlCmds; }
    { groups = [ "wheel" ]; commands = systemdCmds; }
  ];

  environment.systemPackages = with pkgs; [
    v4l-utils  # for `ir-ctl` executable
    git
    libnotify
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
