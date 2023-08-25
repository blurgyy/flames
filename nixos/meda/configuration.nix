{ config, pkgs, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit (pkgs) system config overlays;
  };
in

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
      (pkgs-stable.openai-whisper.override { cudaSupport = true; })
    ];
    sessionVariables.LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"  # required for nvidia-smi to work
    ];
  };

  system.stateVersion = "23.05";
}
