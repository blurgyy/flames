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
      "net.ifnames=0"  # setting this to 0 disables predictable interface names
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
      # "vm.swappiness" = 200;
      # "vm.vfs_cache_pressure" = 50;
      # "vm.dirty_background_ratio" = 5;
      # "vm.dirty_ratio" = 80;
      # REF: <https://www.ibm.com/docs/de/smpi/10.2?topic=mpi-tuning-your-linux-system>
      # "net.core.wmem_default" = 2097152;
      # "net.core.wmem_max" = 4194304;
    };
    initrd = {
      inherit supportedFilesystems;
      availableKernelModules = [
        "nvme_core"
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
        "nvme"
        "nvme_core"
      ];  # There used to be virtio_{blk,scsi,pci,net} modules here, which should already be included in the (modulesPath + "/profiles/qemu-guest.nix") module.
      # REF: <https://github.com/NixOS/nixpkgs/issues/32588#issuecomment-725695984>
      network.ssh = {
        enable = true;
        port = 22;
        authorizedKeys = (import ./public-keys.nix).users;
      };
    };
    tmp.useTmpfs = lib.mkDefault true;
    tmp.tmpfsSize = lib.mkDefault "100%";
    tmp.cleanOnBoot = lib.mkDefault true;
  };

  #kexec.autoReboot = false;  # Use this with inputs.nixos-generators.nixosModules.kexec in `./default.nix`

  services.zram-generator = lib.mkDefault {  # REF: <https://unix.stackexchange.com/a/596929>
    enable = true;
    settings = {  # REF: <https://github.com/systemd/zram-generator/blob/main/zram-generator.conf.example>
      zram0 = {
        host-memory-limit = "none";  # disable maximum amount of memory limit, this is the default
        zram-size = "ram * 2";
        swap-priority = 32767;
        compression-algorithm = "zstd";
      };
    };
  };

  networking.useDHCP = lib.mkDefault false;
  powerManagement.cpuFreqGovernor = if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
    then lib.mkDefault "ondemand"
    else lib.mkDefault null;
}
