{ lib, pkgs, config, headless ? false, ... }: let
  myName = "gy";
  myHome = "/home/${myName}";
  helpers = import ./helpers.nix { inherit lib; };
  callWithHelpers = path: overrides: with builtins; let
    f = import path;
  in if (typeOf f) == "set" then f else let
    args = (intersectAttrs (functionArgs f) { inherit pkgs lib config; } // overrides);
  in f ((intersectAttrs (functionArgs f) helpers) // args);
in lib.mkMerge [
{  # Generic
  home.username = myName;
  home.homeDirectory = myHome;
  home.packages = with pkgs; [
    gcc
    gdb
    git-sync
    libime-history-merge
    lnav
    patchelf
    python3
    sdwrap
    steam-run
    tex2nix
    zellij-hirr
    #texlive.combined.scheme-full  # NOTE: use tex2nix
    #nixos-cn.re-export.telegram-send
    #nixos-cn.dingtalk
  ];

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.stateHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
    defaultCacheTtl = 60480000;
    maxCacheTtl = 60480000;
  };

  programs = {
    git = import ./parts/git.nix;
    ssh = import ./parts/ssh.nix;
    readline = {
      enable = true;
      variables = {
        editing-mode = "vi";
        completion-ignore-case = "On";
      };
    };
    neovim = import ./parts/neovim { inherit pkgs; };
    bat = {
      enable = true;
      config = {
        theme = "Nord";
        style = "numbers,changes,header-filename,header-filesize";
      };
    };
    starship = import ./parts/starship.nix;
    bash = { enable = true; };
    zsh = {
      enable = true;
      initExtraFirst = ''
        typeset -T INFOPATH infopath
        typeset -U PATH MANPATH INFOPATH
        if [[ -o interactive ]]; then
          if [[ -z "$noexecfish" ]]; then
            exec fish
          fi
        fi
      '';
    };
    fzf = { enable = true; };
    fish = callWithHelpers ./parts/fish { };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    DIFFPROG = "nvim -d";
    LESS = "--mouse --wheel-lines=3 --RAW-CONTROL-CHARS";
    LESS_TERMCAP_md = "[1;34;40m";  # set_color --bold brblue --background black
    LESS_TERMCAP_me = "[m";
    LESS_TERMCAP_us = "[1;4;37m";  # set_color --underline --bold brwhite
    LESS_TERMCAP_ue = "[m";
    LESS_TERMCAP_so = "[7;36m";  # set_color --reverse brcyan
    LESS_TERMCAP_se = "[m";
    LESSHISTFILE = "${config.xdg.stateHome}/lesshst";
    CARGO_HOME = "${config.xdg.stateHome}/cargo";
    PAGER = "less";
    MANPAGER = "less";
    MDCAT_PAGER = "less";
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
    PYTHONDONTWRITEBYTECODE = 1;
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    FZF_DEFAULT_OPTS = "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD";
    SKIM_DEFAULT_OPTS = "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD";
  };
  systemd.user.sessionVariables = config.home.sessionVariables;
  pam.sessionVariables = config.home.sessionVariables;

  home.file = {
    ipythonConfig = {
      text = ''
        c.TerminalInteractiveShell.editing_mode = "vi"
        c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
      '';
      target = ".ipython/profile_default/ipython_config.py";
    };
    netrc = {
      text = ''
        machine api.wandb.ai
          login user
          password 0d2ab588e76b70e4af8e6725d73c7df8e141f0ad
      '';
      target = ".netrc";
    };
  };

  xdg = with helpers; {
    enable = true;
    configFile = with builtins; {
      "wakatime/.wakatime.cfg".text = readFile ./parts/raw/wakatime;
    } // (manifestXdgConfigFilesFrom ./parts/mirrored);
  };

  systemd.user = {
    services.blackd = {
      Unit.Documentation = "https://black.readthedocs.io/en/stable/usage_and_configuration/black_as_a_server.html";
      Service = {
        ExecStart = "${pkgs.black}/bin/blackd";
        Restart = "always";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  services = {
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

  home.stateVersion = "22.05";
}

(if !headless then {  # For non-headless machines
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
  wayland.windowManager.sway = callWithHelpers ./parts/sway.nix { };
  fonts.fontconfig.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "system-ui 10";
      document-font-name = "system-ui 10";
      monospace-font-name = "ui-monospace 10";
      text-scaling-factor = 1.5;
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-lua
      libsForQt5.fcitx5-qt
      fcitx5-sogou-themes
      fcitx5-fluent-dark-theme
    ];
  };
  home.packages = with pkgs; [
    evince
    imv
    logseq
    meshlab
    tdesktop-megumifox
    waypipe
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
    xfce.thunar
    xfce.thunar-volman
    zotero
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
      extraConfig = { };
    };
    alacritty = {
      enable = true;
      package = pkgs.alacritty-swarm;
      settings = import ./parts/alacritty.nix;
    };

    firefox = callWithHelpers ./parts/firefox.nix { };

    waybar = {
      settings = callWithHelpers ./parts/waybar { };
      style = callWithHelpers ./parts/waybar/style.css.nix { };
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
      enable = true;
    };
  };
  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;  # TODO: with `config.firefox.package.forceWayland` set to true, maybe this can be removed?
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };
  systemd.user.sessionVariables = config.home.sessionVariables;
  pam.sessionVariables = config.home.sessionVariables;

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
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
        "audio/aac" = "mpv.desktop";
        "audio/mp3" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/wave" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "audio/x-wave" = "mpv.desktop";
        "image/bmp" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/tiff" = "imv.desktop";
        "inode/directory" = "thunar.desktop";
        "text/html" = "firefox.desktop";
        "text/markdown" = "marktext.desktop";
        "text/x-markdown" = "marktext.desktop";
        "video/mp4" = "mpv.desktop";
        "video/vnd.uvvu.mp4" = "mpv.desktop";
        "x-scheme-handler/element" = "io.element.Element.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/terminal" = "Alacritty.desktop";
        "x-scheme-handler/tg" = "telegramdesktop.desktop";
      };
    };
  };
  systemd.user = {
    targets.sway-session.Unit.Wants = [
      "thunar.service"
      "xdg-desktop-autostart.target"
      "systembus-notify.service"
    ];
    services.flameshot = {
      Service.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Pictures/screenshots";
    };
    # HACK: Do not enable fcitx5-daemon.service because xdg-desktop-autostart.target already pulls another fcitx5 service
    services.fcitx5-daemon.Install.WantedBy = lib.mkForce [ ];
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
    flameshot = import ./parts/flameshot.nix;
    dunst = rec {
      enable = true;
      iconTheme = {
        name = "Flat-Remix-Yellow-Dark";
        package = pkgs.flat-remix-icon-theme-proper-trayicons;
      };
      settings = callWithHelpers ./parts/dunst.nix { };
    };
  };
} else {})
]
