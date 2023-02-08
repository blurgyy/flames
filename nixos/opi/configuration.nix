{ pkgs, lib, modulesPath, config, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot = let
    supportedFilesystems = lib.mkForce [  # Remove zfs from supportedFilesystems
      "btrfs" "cifs" "ext4" "f2fs" "ntfs" "reiserfs" "vfat" "xfs"
    ];
  in {
    kernelPackages = pkgs.linuxPackages_latest;
    inherit supportedFilesystems;
    initrd = {
      inherit supportedFilesystems;
      availableKernelModules = [ "usbhid" "usb_storage" ];
    };
  };

  sdImage = {  # REF: <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616#Periphery>
    postBuildCommands = ''
      dd if=${pkgs.ubootOrangePi3Lts}/u-boot-sunxi-with-spl.bin of=$img bs=1k seek=8 conv=notrunc
    '';
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
  hardware.deviceTree = {
    enable = true;
    name = "allwinner/sun50i-h6-orangepi-3-lts.dtb";
    kernelPackage = config.boot.kernelPackages.kernel.overrideAttrs (o: {
      patches = o.patches or [] ++ [ ./add-orangepi-3-lts-device-tree.patch ];
    });
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

  system.stateVersion = "22.11";
}
