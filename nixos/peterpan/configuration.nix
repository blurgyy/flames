{ ... }: {
  time.timeZone = "Asia/Shanghai";

  boot.loader.grub.device = "/dev/vda";
  boot.tmp.useTmpfs = false;
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

  systemd.network.wait-online.extraArgs = [ "--interface=eth0" ];

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
