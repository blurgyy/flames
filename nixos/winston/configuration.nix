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
      options = [ "idmap=user" "Port=13815,Compression=yes,IdentityFile=/home/gy/.ssh/id_ed25519,UserKnownHostsFile=/dev/null,StrictHostKeyChecking=no" "_netdev" "allow_other" ];
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

  users.users.xfer = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.users.users.gy.openssh.authorizedKeys.keys ++ [
      # cyx
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDid9hA/KRba0O9kkm7Vu2jXawkaCREj8Ig31jKCjU9qmXhUFAA/nSCJ0dPPPs6VX9TxFdbVp+Ot48Yd0Y1vJtyX4wCFt4170eCu6rI5eIIJrkFJSsLidF7XTjcbl9Ojfd7WCRvnUMnGV+U+3owEHDcdx9v0IRKQg/D3quYkxUkLiZrGzDeD9jBPBbAUrNQWt7FwImQSqLFqDlbawNDP/ER6ck6s2pCyuM0zu+et7QkvHU6jYaA0BkJw4gSlMY62Di65ICnyN31rSpIcIt/C4+g4bwNfdZTW2akLc6UCg9T2VZzygMdwjjhBun/VK+FbKG94rMSD9OG3o+dMYP0q+stgu9QvZ9t9fzcLaSqLLg8Ujgva8nFYOtd2y2G3OUpcKeP6XAU2/6Nw9HvCUTSBMPT9YekZG4Tl3FMoBFI2B/RxQCczZ+jXfS1oVJ9NEXC+MIYSBr6WGbhdA3YK7VdYuaSTrL2aDGG1sUjs6B/25VwJfysN/drP6a4LB+2nEdcEw0= usr0@master"
    ];
    group = config.users.groups.users.name;
  };

  environment.systemPackages = [
    pkgs.python3Packages.gpustat
  ];

  systemd.services.nix-daemon.environment = rec {
    http_proxy = "http://127.0.0.1:${toString config.services.ssh-reverse-proxy.server.services.http-proxy-from-copi.port}";
    https_proxy = http_proxy;
  };

  services = {
    btrfs.autoScrub.fileSystems = [ "/elements" ];
  };

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  # use LTS kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # REF: <https://nixos.wiki/wiki/Nvidia>
  hardware = {
    nvidia = {
      modesetting.enable = true;
      # NVIDIA's open GPU kernel modules are supported since the "Turing" architecture
      # REF: <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/19>
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  system.stateVersion = "23.05";
}
