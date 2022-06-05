{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "discard=async" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nixos-esp";
    fsType = "vfat";
  };

  fileSystems."/elements" = {
    device = "/dev/disk/by-label/wd-elements";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; }
  ];

  networking.useDHCP = lib.mkDefault false;
  powerManagement.cpuFreqGovernor = "performance";
}
