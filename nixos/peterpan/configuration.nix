{ ... }: {
  time.timeZone = "Asia/Shanghai";

  boot.loader.grub.device = "/dev/vda";
  boot.tmpOnTmpfs = false;
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

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
