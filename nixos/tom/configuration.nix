{ ... }: {
  time.timeZone = "America/Los_Angeles";

  boot.loader.systemd-boot.enable = true;
  boot.tmp.useTmpfs = false;
  disko.devices.disk = {
    main = {
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_52761980";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              mountpoint = "/";
              subvolumes = {
                "/nix/store".mountpoint = "/nix/store";
                "/var/lib/postgresql".mountpoint = "/var/lib/postgresql";
              };
            };
          };
        };
      };
    };
  };

  systemd.network.wait-online.extraArgs = [ "--interface=eth0" ];

  system.stateVersion = "24.11";
}
