{ config, pkgs, lib, hm-config, ... }: let
  helpers = import ./helpers.nix { inherit lib; };
  callWithHelpers = path: overrides: with builtins; let
    f = import path;
  in if (typeOf f) == "set" then f else let
    args = (intersectAttrs (functionArgs f) { inherit config pkgs lib hm-config; } // overrides);
  in f ((intersectAttrs (functionArgs f) helpers) // args);
in {
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-yellow-dark";
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

  home.packages = with pkgs; [
    imv
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
    waypipe
    zellij-hirr
    xfce.thunar
    zotero
    sdwrap
    tdesktop-megumifox
  ];

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

  programs.gpg = {
    enable = true;
    homedir = "${hm-config.xdg.stateHome}/gnupg";
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
      terminal = "${pkgs.alacritty}/bin/alacritty";
      xoffset = 0;
      yoffset = 0;
      location = "center";
      plugins = [ pkgs.rofi-emoji ];
      theme = "catppuccin";
      extraConfig = { };
    };

    neovim = import ./parts/neovim { inherit pkgs; };

    alacritty = {
      enable = true;
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

    bat = {
      enable = true;
      config = {
        theme = "Nord";
        style = "numbers,changes,header-filename,header-filesize";
      };
    };
    starship = {
      enable = true;
      settings = {
        format = "$all";
        scan_timeout = 30;
        command_timeout = 500;
        add_newline = false;
        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[✗](bold red)";
          vicmd_symbol = "[](bold blue)";
        };
        time = {
          disabled = false;
          format = "at [$time]($style) ";
          style = "bold yellow";
          use_12hr = false;
          utc_time_offset = "local";
          time_range = "-";
        };
      };
    };
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
    LESSHISTFILE = "${hm-config.xdg.stateHome}/lesshst";
    CARGO_HOME = "${hm-config.xdg.stateHome}/cargo";
    PAGER = "less";
    MANPAGER = "less";
    MDCAT_PAGER = "less";
    WAKATIME_HOME = "${hm-config.xdg.configHome}/wakatime";
    PYTHONDONTWRITEBYTECODE = 1;
    XDG_SESSION_DESKTOP = "sway";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    MOZ_ENABLE_WAYLAND = 1;  # TODO: with `hm-config.firefox.package.forceWayland` set to true, maybe this can be removed?
    WINEPREFIX = "${hm-config.xdg.dataHome}/wine";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    FZF_DEFAULT_OPTS = "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD";
    SKIM_DEFAULT_OPTS = "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD";
  };
  systemd.user.sessionVariables = hm-config.home.sessionVariables;
  pam.sessionVariables = hm-config.home.sessionVariables;

  xdg = with helpers; {
    enable = true;
    configFile = with builtins; {
      "wakatime/.wakatime.cfg".text = readFile ./parts/raw/wakatime;
    } // (manifestXdgConfigFilesFrom ./parts/mirrored);
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

  home.stateVersion = "22.05";
}

