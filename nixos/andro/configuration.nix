{ ... }: {
  time.timeZone = "Asia/Shanghai";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "gy";
    startMenuLaunchers = true;
  };

  presets.development = true;
  system.stateVersion = "23.05";
}
