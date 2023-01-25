{ ... }: {
  time.timeZone = "Asia/Tokyo";

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

  networking = {
    defaultGateway = "193.32.148.1";
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "193.32.151.152";
        prefixLength = 22;
      }];
    };
  };

  services = {
    rustdesk-server.enable = true;
    udisks2.enable = false;
  };

  system.stateVersion = "22.11";
}
