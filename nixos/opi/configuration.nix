{ pkgs, modulesPath, ... }: {
  time.timeZone = "Asia/Shanghai";

  # needed for building sd-card image, REF: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];

  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  };

  sdImage = {  # REF: <https://nixos.wiki/wiki/NixOS_on_ARM/Orange_Pi_Zero2_H616#Periphery>
    postBuildCommands = ''
      dd if=${pkgs.ubootOrangePi3Lts}/u-boot-sunxi-with-spl.bin of=$img bs=8 seek=1024 conv=notrunc
    '';
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

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
