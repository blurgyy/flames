{ config, ... }: {
  boot.loader.systemd-boot.enable = true;
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

  # Workaround broken ZFS module in kernel packages
  nixpkgs.config.allowBroken = true;

  networking.hostName = "cindy";
  time.timeZone = "Europe/Berlin";

  system.stateVersion = "22.11";
}
