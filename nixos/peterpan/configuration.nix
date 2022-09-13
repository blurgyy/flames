{ ... }: {
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

  nix.settings.sandbox-dev-shm-size = "300%";

  networking.hostName = "peterpan";
  time.timeZone = "Asia/Shanghai";

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
