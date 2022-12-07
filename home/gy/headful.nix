{ config, pkgs, lib, myHome, callWithHelpers, ... }: {  # For non-headless machines
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Yellow-Dark";
    };
    iconTheme = {
      package = pkgs.flat-remix-icon-theme-proper-trayicons;
      name = "Flat-Remix-Yellow-Dark";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Classic";
    size = 24;
    gtk.enable = true;
  };
  wayland.windowManager = {
    sway = callWithHelpers ./parts/sway.nix { inherit config; };
    hyprland = callWithHelpers ./parts/hyprland.nix { inherit config; };
  };
  fonts.fontconfig.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "system-ui 10";
      document-font-name = "system-ui 10";
      monospace-font-name = "ui-monospace 10";
      text-scaling-factor = 1.5;
    };
  };
  home.packages = with pkgs; [
    cider
    colmena
    evince
    imv
    libnotify
    logseq
    meshlab
    obs-studio
    rustdesk-with-x11-desktopentry
    tdesktop-megumifox
    wf-recorder-respect-pixel-format
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
    wlr-randr
    wpsoffice-cn
    xfce.thunar
    xfce.thunar-volman
    zotero
  ] ++ [  # fonts
    rubik
    (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
    (iosevka-bin.override { variant = "sgr-iosevka-slab"; })
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    font-awesome
    freefont_ttf
    liberation_ttf
    lxgw-wenkai
    harmonyos-sans
    symbols-nerd-font
    vscode-codicons
    apple-color-emoji
  ];
  programs = {
    mpv = {
      enable = true;
      config = {
        save-position-on-quit = true;
        hwdec = "auto";
        tone-mapping = "hable";
        hdr-compute-peak = "yes";
      };
      scripts = with pkgs.mpvScripts; [ mpris ];
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      font = "slab-serif 15";
      terminal = "${pkgs.alacritty-swarm}/bin/alacritty";
      xoffset = 0;
      yoffset = 0;
      location = "center";
      plugins = [ pkgs.rofi-emoji ];
      theme = "catppuccin";
      # extraConfig.ssh-client = "waypipe ssh";
    };
    alacritty = {
      enable = true;
      package = pkgs.alacritty-swarm;
      settings = callWithHelpers ./parts/alacritty.nix {};
    };

    firefox = callWithHelpers ./parts/firefox.nix { inherit config; };
    waybar = callWithHelpers ./parts/waybar {};
  };
  home.sessionVariables = {
    XCURSOR_THEME = config.home.pointerCursor.name;
    XCURSOR_SIZE = toString config.home.pointerCursor.size;
    XDG_SESSION_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;  # TODO: with `config.firefox.package.forceWayland` set to true, maybe this can be removed?
    _JAVA_AWT_WM_NONREPARENTING = 1;
    QT_PLUGIN_PATH = "${pkgs.libsForQt5.fcitx5-qt}/${pkgs.qt6.qtbase.qtPluginPrefix}\${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}";
    NO_AT_BRIDGE = 1;  # REF: <https://github.com/NixOS/nixpkgs/issues/16327#issuecomment-315729994>
  };

  xdg = {
    enable = true;
    systemDirs.data = [
      "${myHome}/.nix-profile/share"
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"  # REF: <https://github.com/NixOS/nixpkgs/issues/72282#issuecomment-549651957>
    ];
    configFile."hypr/hyprland.conf".onChange = lib.mkForce "";
    mimeApps = {
      enable = true;
      defaultApplications = builtins.mapAttrs (_: app: "supervised-" + app) {
        "application/mp4" = "mpv.desktop";
        "application/octet-stream" = "firefox.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "application/vnd.ms-excel" = "wps-office-et.desktop";
        "application/vnd.ms-powerpoint" = "wps-office-wpp.desktop";
        "application/vnd.ms-word" = "wps-office-wps.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "wps-office-wpp.desktop";
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "wps-office-et.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "wps-office-wps.desktop";
        "application/x-zerosize" = "nvim.desktop";
        "inode/directory" = "thunar.desktop";
        "text/html" = "firefox.desktop";
        "text/markdown" = "marktext.desktop";
        "text/x-markdown" = "marktext.desktop";
        "x-scheme-handler/element" = "io.element.Element.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/terminal" = "Alacritty.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";

        # wildcards (use with `handlr open`)
        "audio/*" = "mpv.desktop";
        "video/*" = "mpv.desktop";
        "image/*" = "imv.desktop";
      };
    };
  };
  systemd.user = {
    targets = let
      wm-session-wants = [
        "thunar.service"
        "systembus-notify.service"
      ];
    in {
      sway-session.Unit.Wants = wm-session-wants;
    } // (lib.optionalAttrs config.wayland.windowManager.hyprland.enable {
      hyprland-session.Unit.Wants = wm-session-wants;
    });
    services.flameshot = {
      Service.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Pictures/screenshots";
    };
    services.hyprpaper = lib.optionalAttrs config.wayland.windowManager.hyprland.enable {
      Unit.X-Restart-Triggers = [ (with builtins; hashString "sha512" (readFile ./parts/mirrored/hypr/hyprpaper.conf.asnix)) ];
      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "always";
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
    services.waybar = {
      Service.Environment = [ "PATH=${lib.makeBinPath [ pkgs.hyprland-XDG_CURRENT_DESKTOP-sway ]}" ];
      Install.WantedBy = [ "graphical-session.target" ]
        ++ (lib.optional config.wayland.windowManager.hyprland.enable "hyprland-session.target");
    };
  };

  services = {
    gammastep = {
      enable = true;
      latitude = 30.31;
      longitude = 120.16;
      provider = "manual";
      tray = true;
      temperature = {
        day = 6500;
        night = 4500;
      };
      settings = {
        general = {
          adjustment-method = "wayland";
          fade = 1;
          gamma = 0.8;
        };
      };
    };
    flameshot = callWithHelpers ./parts/flameshot.nix {};
    dunst = {
      enable = true;
      iconTheme = {
        name = "Flat-Remix-Yellow-Dark";
        package = pkgs.flat-remix-icon-theme-proper-trayicons;
      };
      settings = callWithHelpers ./parts/dunst.nix { inherit config; };
    };
    git-sync = {
      enable = true;
      repositories = {
        logseq = {
          interval = 1200;  # pull for changes 3 times per hour
          path = "${myHome}/Repos/CHR/logseq";
          uri = "git+ssh://git@github.com/blurgyy/logseq.git";
        };
      };
    };
  };
}
