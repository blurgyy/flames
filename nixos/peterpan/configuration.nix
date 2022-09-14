{ ... }: {
  networking.hostName = "peterpan";
  time.timeZone = "Asia/Shanghai";

  boot.loader.grub.device = "/dev/vda";
  fileSystems = {
    "/" = {  
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-boot";
      fsType = "vfat";
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; priority = 0; }
  ];

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
