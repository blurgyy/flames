{ pkgs, lib, modulesPath, config, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.opi3lts-kernel-latest;
    kernelModules = [
      # NOTE: Enables wireless driver for uwe5622 (though the board says aw859a), needs
      # /lib/firmware/wifi_2355b001_1ant.ini and /lib/firmware/wcnmodem.bin to work.
      # WARN: see below configs on `systemd.services.systemd-modules-load`
      "sprdwl_ng"
    ];
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  };

  # The /boot/firmware filesystem also uses the same block device, but it has the "noauto" option,
  # so it should not b a problem (mounting a vfat file system twice at the same is forbidden).
  fileSystems."/lib/firmware" = {
    device = "/dev/disk/by-label/${config.sdImage.firmwarePartitionName}";
    fsType = "vfat";
    options = [ "ro" "nofail" ];
  };
  # WARN: only load the sprdwl_ng module after /lib/firmware is mounted.
  # To make sure the module can be loaded, /lib/firmware can be firstly populated with the firmware
  # blobs, so that failing to mount
  systemd.services.systemd-modules-load = let
    firmwareMountingService = "lib-firmware.mount";
  in {
    # man:systemd.unit(5)
    # Units listed in this option will be started if the configuring unit is. However, if the listed
    # units fail to start or cannot be added to the transaction, this has no impact on the validity
    # of the transaction as a whole, and this unit will still be started. This is the recommended
    # way to hook the start-up of one unit to the start-up of another unit.
    wants = [ firmwareMountingService ];

    # man:systemd.unit(5)
    # If unit foo.service pulls in unit bar.service as configured with Wants= and no ordering is
    # configured with After= or Before=, then both units will be started simultaneously and without
    # any delay between them if foo.service is activated.
    after = [ firmwareMountingService ];
  };

  fileSystems."/elements" = {
    device = "/dev/disk/by-label/wd-elements";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
  };

  environment.systemPackages = [
    pkgs.transmission
  ];

  sdImage = {
    firmwarePartitionName = "FIRMWARE";
    firmwareSize = 64;
    populateFirmwareCommands = ''
      rm -vrf firmware
      cp -vr ${pkgs.opi-firmware}/lib/firmware .
    '';
    # REF: <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616#Periphery>
    postBuildCommands = ''
      dd if=${pkgs.opi3lts-uboot}/uboot.bin of=$img bs=1k seek=8 conv=notrunc
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

  system.stateVersion = "23.05";
}
