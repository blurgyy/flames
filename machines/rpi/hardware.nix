{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];
  boot = {
    supportedFilesystems = [ "btrfs" "ext4" ];
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "dev.i915.perf_stream_paranoid" = 0;
      "kernel.sysrq" = 1;
      "vm.swappiness" = 200;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 80;
    };
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "100%";
  };
  zramSwap = {  # REF: <https://unix.stackexchange.com/a/596929>
    enable = true;
    priority = 32767;
    memoryPercent = 150;
  };
  fileSystems."/elements" = {
    device = "/dev/disk/by-label/wd-elements";
    fsType = "btrfs";
    options = [ "noatime" "compress-force=zstd:3" "autodefrag" "nofail" ];
  };
}
