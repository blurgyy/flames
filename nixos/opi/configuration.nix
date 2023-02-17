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
      # NOTE: Enables wireless driver for uwe5622 (though the borad says aw859a), needs
      # /lib/firmware/wifi_2355b001_1ant.ini and /lib/firmware/wcnmodem.bin to work.
      "sprdwl_ng"
    ];
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  };

  # WARN: put firmwares into /lib/firmware and switch system profile to change them to read-only
  # mode via chattr
  # After this, the file `/lib/firmware/wcnmodem.bin` should exist for the wireless module to work.
  # REF: man:tmpfiles.d(5), man:chattr(1)).
  systemd.tmpfiles.rules = [
    "H /lib/firmware/* - - - - i"
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
      dd if=${pkgs.opi3lts-uboot}/7pvzzppwwaqvg9mjqv2jsc3v7m1fv8i4-uboot.bin of=$img bs=1k seek=8 conv=notrunc
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
