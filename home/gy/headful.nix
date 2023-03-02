{ config, pkgs, lib, myHome, __callWithHelpers, ... }: let
  callWithHelpers = f: override: __callWithHelpers f (override // { inherit config callWithHelpers; });
in {  # For non-headless machines
  ricing.headful.theme = "dark";
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
  gtk = {
    cursorTheme = {
      inherit (config.home.pointerCursor) package name size;
    };
    gtk3.bookmarks = [
      "file:///elements"
      "file:///home/gy/Downloads"
      "file:///home/gy/Playground"
      "file:///home/gy/Repos"
      "file:///run/user/1000"
      "file:///tmp"
    ];
  };
  wayland.windowManager = {
    sway = callWithHelpers ./parts/sway.nix {};
    hyprland = callWithHelpers ./parts/hyprland.nix {};
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
    cage
    cider
    colmena
    evince
    gimp
    imv
    libnotify
    logseq
    meshlab
    minicom
    obs-studio
    rustdesk-with-x11-desktopentry
    tdesktop-megumifox
    re-export.wemeet-linyinfeng
    wf-recorder-respect-pixel-format
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
    wlr-randr
    #wpsoffice-cn
    xfce.thunar
    xfce.thunar-volman
    zotero
  ] ++ [  # fonts
    rubik
    (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
    (iosevka-bin.override { variant = "sgr-iosevka-slab"; })
    source-serif-pro
    source-sans-pro
    source-code-pro
    source-han-serif
    source-han-sans
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    gsfonts
    font-awesome
    freefont_ttf
    liberation_ttf
    lxgw-wenkai
    harmonyos-sans
    symbols-nerd-font
    vscode-codicons
    apple-color-emoji
  ] ++ lib.optional (pkgs.system == "x86_64-linux" || pkgs.system == "i686-linux") steam-run;
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

    firefox = callWithHelpers ./parts/firefox.nix {};
    waybar = callWithHelpers ./parts/waybar {};
  };
  home.sessionVariables = {
    XCURSOR_THEME = config.home.pointerCursor.name;
    XCURSOR_SIZE = config.home.pointerCursor.size;
    XDG_SESSION_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
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
  };
  systemd.user = {
    targets = let
      wm-session-wants = [
        "thunar.service"
        "systembus-notify.service"
      ];
    in {
      sway-session.Unit.Wants = wm-session-wants;
      hyprland-session.Unit.Wants = lib.mkIf config.wayland.windowManager.hyprland.enable wm-session-wants;
    };
    services.flameshot = {
      Service.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Pictures/screenshots";
    };
    services.hyprpaper = lib.optionalAttrs config.wayland.windowManager.hyprland.enable {
      Unit.X-Restart-Triggers = [ (with builtins; hashString "sha512" (readFile ./parts/mirrored/hypr/hyprpaper.conf.asnix)) ];
      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "always";
        RestartSec = 1;
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
    services.waybar = {
      Service.Environment = [ "PATH=${lib.makeBinPath [ pkgs.hyprland-XDG_CURRENT_DESKTOP-sway ]}" ];
      Install.WantedBy = [ "graphical-session.target" ]
        ++ (lib.optional config.wayland.windowManager.hyprland.enable "hyprland-session.target");
    };
    services.fcitx5-daemon.Service.ExecStart = lib.mkForce "${config.i18n.inputMethod.package}/bin/fcitx5 --replace";
  };

  services = {
    gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      pinentryFlavor = "tty";
      defaultCacheTtl = 3600 * 24;
      maxCacheTtl = 3600 * 48;
      enableScDaemon = false;
    };
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
      settings = callWithHelpers ./parts/dunst.nix {};
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
