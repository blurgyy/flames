{ config, pkgs, ... }: {
  time.timeZone = "Asia/Shanghai";

  boot.loader.systemd-boot.enable = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "discard=async" "subvol=nix" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-esp";
      fsType = "vfat";
    };
    "/broken" = {
      device = "/dev/disk/by-label/broken";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
    };
    "/nfs" = {
      device = "/run/current-system/sw/bin/sshfs#gy@localhost:/home/gy/.local/share/nfs";
      fsType = "fuse";
      options = [ "idmap=user" "Port=13815,Compression=no,IdentityFile=/home/gy/.ssh/id_ed25519,UserKnownHostsFile=/dev/null,StrictHostKeyChecking=no" "_netdev" "allow_other" ];
    };
    "/elements" = {
      device = "/dev/disk/by-label/wd-elements";
      fsType = "btrfs";
      options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-label/nixos-swap"; priority = 0; }
  ];

  services = {
    btrfs.autoScrub.fileSystems = [ "/elements" ];
  };

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # use LTS kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # REF: <https://nixos.wiki/wiki/Nvidia>
  hardware.nvidia = {
    modesetting.enable = true;
    # NVIDIA's open GPU kernel modules are supported since the "Turing" architecture
    # REF: <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/19>
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "23.05";
}
