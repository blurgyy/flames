{ config, lib, pkgs, ... }: {
  #assertions = [{
  #  assertion = with config.boot.loader; (grub.enable || systemd-boot.enable || generic-extlinux-compatible.enable);
  #  message = ''
  #    At least one of `boot.loader.generic-extlinux-compatible`, `boot.loader.systemd-boot` or
  #    `boot.loader.grub` must be enabled
  #  '';
  #}];

  hardware.cpu = lib.mkIf (pkgs.system == "x86_64-linux") {
    intel.updateMicrocode = lib.mkDefault true;
    amd.updateMicrocode = lib.mkDefault true;
  };
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot = let
    supportedFilesystems = lib.mkForce [  # Remove zfs from supportedFilesystems
      "btrfs" "cifs" "ext4" "f2fs" "ntfs" "reiserfs" "vfat" "xfs"
    ];
  in {
    inherit supportedFilesystems;
    loader.efi.canTouchEfiVariables = lib.mkDefault config.boot.loader.systemd-boot.enable;
    kernelParams = [
      "pcie_aspm=off"
      "mitigations=off"
      "net.ifnames=0"  # predictable interface names
      "resume=LABEL=nixos-swap"
      "boot.shell_on_fail"
      "loglevel=4"
    ];
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "dev.i915.perf_stream_paranoid" = 0;
      "kernel.sysrq" = 1;
      "vm.swappiness" = 200;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 80;
      # REF: <https://www.ibm.com/docs/de/smpi/10.2?topic=mpi-tuning-your-linux-system>
      "net.core.wmem_default" = 2097152;
      "net.core.wmem_max" = 4194304;
    };
    initrd = {
      inherit supportedFilesystems;
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];  # There used to be virtio_{blk,scsi,pci,net} modules here, which should already be included in the (modulesPath + "/profiles/qemu-guest.nix") module.
      # REF: <https://github.com/NixOS/nixpkgs/issues/32588#issuecomment-725695984>
      network.ssh = let
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaSjivabf9fojBuWsmiLvCElj1sEILE0N8x8X7zM7Gk gy@rpi"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4yanex/42s/F9dP7CJ3BstzEC7n0qwi0+2hhxOAS6 gy@hooper"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdK4KWp4YMiDfq+hLZ3fQQ+02XnYhLY47l7Zro+xKud gy@watson"
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
    tmpOnTmpfs = lib.mkDefault true;
    tmpOnTmpfsSize = lib.mkDefault "100%";
  };

  #kexec.autoReboot = false;  # Use this with inputs.nixos-generators.nixosModules.kexec in `./default.nix`

  zramSwap = lib.mkDefault {  # REF: <https://unix.stackexchange.com/a/596929>
    enable = true;
    priority = 32767;
    memoryPercent = 200;
    swapDevices = 1;  # NOTE: workwround <https://github.com/NixOS/nixpkgs/pull/214103>
  };

  networking.useDHCP = lib.mkDefault false;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
