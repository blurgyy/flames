{ ... }: {
  boot.loader.grub.device = "/dev/sda";
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


  networking.hostName = "cube";
  time.timeZone = "Asia/Hong_Kong";

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
