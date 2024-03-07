{ config, ... }:

{
  time.timeZone = "Asia/Shanghai";

  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
      network = {
        generateResolvConf = false;  # do not use WSL-generated resolv.conf if DNS is self-managed
        generateHosts = false;
      };
    };
    defaultUser = "gy";
    startMenuLaunchers = true;
  };

  # environment = {
  #   systemPackages = [
  #     config.boot.kernelPackages.nvidiaPackages.stable  # provides the nvidia-smi binary
  #   ];
  #   sessionVariables.LD_LIBRARY_PATH = [
  #     "/usr/lib/wsl/lib"  # required for nvidia-smi to work
  #   ];
  # };

  # herm stores GPG secret keys
  services.openssh.settings.StreamLocalBindUnlink = false;

  system.stateVersion = "23.11";
}
