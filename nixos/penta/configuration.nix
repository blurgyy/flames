{ ... }: {
  time.timeZone = "Europe/Berlin";

  boot.loader.grub.device = "/dev/sda";
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

  networking = {
    defaultGateway = "109.71.253.1";
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "109.71.253.196";
        prefixLength = 24;
      }];
    };
  };

  services.udisks2.enable = false;

  system.stateVersion = "23.11";
}
