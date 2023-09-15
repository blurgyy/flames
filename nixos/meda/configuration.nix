{ config, ... }:

{
  time.timeZone = "Asia/Shanghai";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "gy";
    startMenuLaunchers = true;
  };

  environment = {
    systemPackages = [
      config.boot.kernelPackages.nvidiaPackages.stable  # provides the nvidia-smi binary
    ];
    sessionVariables.LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"  # required for nvidia-smi to work
    ];
  };

  system.stateVersion = "23.05";
}
