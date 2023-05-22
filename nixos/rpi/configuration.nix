{ pkgs, modulesPath, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot = {
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

  fileSystems."/elements" = {
    device = "/dev/disk/by-label/wd-elements";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
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

  # Free up to 1GiB whenever there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  environment.systemPackages = with pkgs; [
    transmission
  ];

  documentation.nixos.enable = false;

  powerManagement.cpuFreqGovernor = "powersave";

  system.stateVersion = "22.05";
}
