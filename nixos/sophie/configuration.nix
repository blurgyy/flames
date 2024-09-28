{ ... }: {
  time.timeZone = "Asia/Shanghai";

  boot.loader.grub.device = "/dev/vda";
  boot.tmp.useTmpfs = false;
  disko.devices.disk = {
    main = {
      # default image format is raw, it has been changed to qcow2 with
      #   `disko.imageBuilder.imageFormat = "qcow2"`;
      imageSize = "8G";
      device = "/dev/disk/by-id/virtio-bp15tehyhsf94hghb9mm";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          BIOS-boot = {
            size = "1M";
            type = "EF02";
          };
          boot = {
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
                "/nix".mountpoint = "/nix";
                "/var/lib/soft-serve".mountpoint = "/var/lib/soft-serve";
              };
            };
          };
        };
      };
    };
  };

  systemd.network.wait-online.extraArgs = [ "--interface=eth0" ];

  services.udisks2.enable = false;

  system.stateVersion = "22.11";
}
