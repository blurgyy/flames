{ pkgs, ... }: {
  services = {
    gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      pinentryPackage = pkgs.pinentry-tty;
      defaultCacheTtl = 3600 * 24;
      maxCacheTtl = 3600 * 48;
      enableScDaemon = false;
    };
  };
  programs.gpg.settings.no-autostart = false;
}
