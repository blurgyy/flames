{ pkgs, lib, modulesPath, config, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];

  boot = let
    supportedFilesystems = lib.mkForce [  # Remove zfs from supportedFilesystems
      "btrfs" "cifs" "ext4" "f2fs" "ntfs" "reiserfs" "vfat" "xfs"
    ];
  in {
    kernelPackages = pkgs.linuxPackagesFor pkgs.opi3lts-kernel-latest;
    kernelModules = [
      # NOTE: Enables wireless driver for uwe5622 (though the borad says aw859a), needs
      # /lib/firmware/wifi_2355b001_1ant.ini and /lib/firmware/wcnmodem.bin to work.
      "sprdwl_ng"
    ];
    inherit supportedFilesystems;
    initrd = {
      inherit supportedFilesystems;
      availableKernelModules = [ "usbhid" "usb_storage" ];
    };
  };

  fileSystems."/lib/firmware" = {
    device = "/dev/disk/by-label/${config.sdImage.firmwarePartitionName}";
    fsType = "vfat";
    options = [ "ro" "nofail" ];
  };

  sdImage = {
    firmwarePartitionName = "FIRMWARE";
    firmwareSize = 64;
    populateFirmwareCommands = ''
      rm -vrf firmware
      cp -vr ${pkgs.opi-firmware}/lib/firmware .
    '';
    # REF: <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616#Periphery>
    postBuildCommands = ''
      dd if=${pkgs.opi3lts-uboot}/u-boot-sunxi-with-spl.bin of=$img bs=1k seek=8 conv=notrunc
    '';
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree = {
    enable = true;
    name = "allwinner/sun50i-h6-orangepi-3-lts.dtb";  # needs gitlab:highsunz/orangepi-3-lts-support
  };

  # Free up to 1GiB whenever there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  documentation.nixos.enable = false;

  system.stateVersion = "22.11";
}
