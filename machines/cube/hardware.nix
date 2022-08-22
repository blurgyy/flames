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
    initrd = {
      availableKernelModules = [ "virtio_pci" ];  # REF: <https://nixos.wiki/wiki/Remote_LUKS_Unlocking#Set_up_SSH_in_initrd>
      postDeviceCommands = "sleep 2";  # REF: <https://github.com/NixOS/nixpkgs/issues/32588#issuecomment-725695984>
      network.ssh = let
        keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKco1z3uNTuYW7eVl2MTPrvVG5jnEnNJne/Us+LhKOwC gy@rpi"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4yanex/42s/F9dP7CJ3BstzEC7n0qwi0+2hhxOAS6 gy@hooper"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdK4KWp4YMiDfq+hLZ3fQQ+02XnYhLY47l7Zro+xKud gy@watson"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYfrTPDWGRcxfnmDU88HLoDrWekz+yTZHk68/75FtDX gy@Blurgy"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlMIWDojT8L4g7g0z6uC2EhALHr2fL/ZIdNnNiyggBj gy@HUAWEI"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1LWYTkOiaY/TSs9qoAAQm2tVHw4Lljz90pCREnW2Zx gy@FridaY"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlA0ON/HBEhGPo1Uu5lrgpbQ/D/Ivd7q3LuNTXScrRi gy@john"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1m/+k7RnoL1YVbP4vv8XTFnlP6CGmnXJfxA+Xu6H5q gy@morty"
          ];
      in {
        enable = true;
        port = 22;
        authorizedKeys = keys;
      };
    };
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
