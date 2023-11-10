{ config, pkgs, lib, myHome, helpers, __callWithHelpers, ... }: let
  callWithHelpers = f: override: __callWithHelpers f (override // { inherit config callWithHelpers; });
in {
  imports = [
    ./parts/localsend.nix
    ./parts/gpg-agent.nix
    ./parts/sway.nix
  ];
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
      "file:///broken"
      "file:///elements"
      "file:///home/gy/Downloads"
      "file:///home/gy/Playground"
      "file:///home/gy/Repos"
      "file:///run/user/1000"
      "file:///tmp"
    ];
  };
  fonts.fontconfig.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "system-ui 10";
      document-font-name = "system-ui 10";
      monospace-font-name = "ui-monospace 10";
      # for native wayland apps, applying both text-scaling-factor here and setting GDK_DPI_SCALE
      # would scale twice.
      # text-scaling-factor = 1.5;
    };
  };

  home.packages = with pkgs; [
    cage
    cider  # uses insecure electron-24.8.6
    evince
    gimp
    imv
    libnotify
    localsend
    logseq  # uses insecure electron-24.8.6
    meshlab
    minicom
    obs-studio
    printer-cadlab
    rustdesk-with-default-and-x11-desktopentry
    slurp
    tdesktop-megumifox
    typst
    video-compare
    wf-recorder
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
    wlr-randr
    #wpsoffice-cn
    xdragon
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
    sc-fonts  # Times New Roman, FangSong, SimHei
    fonts-collection  # FangSong, SimHei, etc.
  ] ++ lib.optional (let
    inherit (pkgs.stdenv.hostPlatform) system;
  in builtins.elem system [ "x86_64-linux" "i686-linux"]) steam-run;
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

    zsh.initExtraFirst = lib.optionalString (pkgs.stdenv.hostPlatform.system == "x86_64-linux") ''
      # test variable is set, REF: <https://stackoverflow.com/a/42655305/13482274>
      if [[ -z "''${__tested_os_release+1}" ]]; then
        source /etc/os-release
        [[ "NixOS" == "$NAME" ]] || {
          source <(sed -Ee '/exec/d' ${pkgs.nixGLIntel}/bin/nixGLIntel)
          systemctl --user import-environment $(grep -E 'export \w+=' ${pkgs.nixGLIntel}/bin/nixGLIntel | cut -d= -f1 | cut -d' ' -f2)
        }
        export __tested_os_release=1
      fi
    '';
  };
  home.sessionVariables = {
    GDK_DPI_SCALE = "1.5";
    XCURSOR_THEME = config.home.pointerCursor.name;
    XCURSOR_SIZE = config.home.pointerCursor.size;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    NO_AT_BRIDGE = 1;  # REF: <https://github.com/NixOS/nixpkgs/issues/16327#issuecomment-315729994>
    TYPST_FONT_PATHS = "${config.home.profileDirectory}";
  };

  xdg = {
    enable = true;
    systemDirs.data = [
      "${config.home.profileDirectory}/share"
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"  # REF: <https://github.com/NixOS/nixpkgs/issues/72282#issuecomment-549651957>
    ];
    configFile = helpers.manifestXdgConfigFilesFrom {
      inherit config;
      pathPrefix = ./parts/mirrored/headful;
    };
  };
  systemd.user = {
    services.flameshot.Service.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Pictures/screenshots";
    services.waybar.Install.WantedBy = [ "graphical-session.target" ];
  };

  services = {
    ntfy-bridge = {
      enable = true;
      defaultHost = "ntfy.blurgy.xyz";
      topics = [
        "billboard"
        "machines"
      ];
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
