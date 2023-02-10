{ ... }: {
  time.timeZone = "Europe/Berlin";

  boot.loader.systemd-boot.enable = true;
  boot.tmpOnTmpfs = false;
  fileSystems = {
    "/" = {  
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-esp";
      fsType = "vfat";
    };
  };

  system.stateVersion = "22.11";
}
