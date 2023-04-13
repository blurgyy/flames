{ ... }: {
  time.timeZone = "Europe/Berlin";

  boot.loader.systemd-boot.enable = true;
  boot.tmp.useTmpfs = false;
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

  systemd.network.wait-online.extraArgs = [ "--interface=eth0" ];

  system.stateVersion = "22.11";
}
