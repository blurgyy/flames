{ config, lib, ... }: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  systemd.user.services = {
    kdeconnect = {
      Service = {
        Environment = lib.mkForce [
          "PATH=${config.home.profileDirectory}/bin"
          # Run for headless profiles, as wayland window managers do not have great mouse/keyboard
          # remote-controlling support anyway.
          # The wiki says to use `.../libexec/kdeconnectd -platform offscreen`, but using the
          # `QT_QPA_PLATFORM` environment can also work (see source).
          # REF: <https://userbase.kde.org/KDEConnect#Can_I_run_KDE_Connect_without_a_display_server.3F>
          "QT_QPA_PLATFORM=offscreen"
          # HACK: on headful profiles (where sessionVariables contains other QT_* environment
          #       variables), we want to clear other QT_* environment variables so that kdeconnectd
          #       really thinks it runs inside a headless (or in QT's term, offscreen) environment.
          "QT_QPA_PLATFORMTHEME="
        ];
      };
      Install.WantedBy = [
        "default.target"
      ];
    };
    kdeconnect-indicator.Service.Environment = lib.mkForce [
      "QT_SCALE_FACTOR=1.5"
    ];
  };
}
