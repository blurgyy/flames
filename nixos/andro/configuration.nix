{ ... }: {
  time.timeZone = "Asia/Shanghai";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "gy";
    startMenuLaunchers = true;
  };

  system.stateVersion = "23.05";
}
