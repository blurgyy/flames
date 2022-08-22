{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware = {
    cpu.intel.updateMicrocode = true;
  };

  boot = {
    kernel = {
      sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "dev.i915.perf_stream_paranoid" = 0;
        "kernel.sysrq" = 1;
        "vm.swappiness" = 1;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 80;
      };
    };
    # NOTE: Omit `boot.kernelPackages` to use the LTS kernel
    # kernelPackages = pkgs.linuxPackages_lts;
    kernelParams = [
      "pcie_aspm=off"
      "mitigations=off"
      "net.ifnames=0"  # predictable interface names
    ];
    loader = {
      grub.enable = true;
      grub.device = "/dev/sda";
    };
    initrd.postDeviceCommands = "sleep 2";  # REF: <https://github.com/NixOS/nixpkgs/issues/32588#issuecomment-725695984>
  };

  #kexec.autoReboot = false;  # Use this with inputs.nixos-generators.nixosModules.kexec in `./default.nix`

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos-root";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "discard=async" ];
  };
  /* swapDevices = [ */
  /*   { device = "/dev/disk/by-label/nixos-swap"; priority = 0; } */
  /* ]; */
  zramSwap = {  # REF: <https://unix.stackexchange.com/a/596929>
    enable = true;
    priority = 32767;
    memoryPercent = 150;
  };

  networking.useDHCP = lib.mkDefault false;
  powerManagement.cpuFreqGovernor = "performance";
}
