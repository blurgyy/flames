{ lib, pkgs, config, name, headless ? true, proxy ? null, ... }: let
  myName = "gy";
  myHome = "/home/${myName}";
  helpers = import ./helpers.nix { inherit lib; };
  callWithHelpers = path: overrides: with builtins; let
    f = import path;
  in if (typeOf f) == "set" then f else let
    args = (intersectAttrs (functionArgs f) { inherit pkgs lib config name; } // overrides);
  in f ((intersectAttrs (functionArgs f) helpers) // args);
in lib.mkMerge [
{  # Generic
  home.username = myName;
  home.homeDirectory = myHome;
  home.packages = with pkgs; [
    bat
    btop
    cachix
    dua
    dogdns
    exa
    exiftool
    fd
    file
    fish
    fzf
    gcc
    gdb
    git
    git-sync
    gnutar
    htop
    hydra-check
    imagemagick
    jq
    less
    lfs
    libime-history-merge
    libqalculate
    lnav
    lsof
    miniserve
    parallel
    patchelf
    procs
    q-text-as-data
    ripgrep
    sdwrap
    sops
    sshfs
    strace
    tex2nix
    tinytools
    unar
    unzip
    util-linux
    viddy
    waypipe
    wget
    yt-dlp
    zip
    zsh
    zstd
    (python3.withPackages (p: with p; [
      click
      icecream
      ipython
      matplotlib
      numpy
      pillow
      plyfile
      tqdm
    ]))
    #texlive.combined.scheme-full  # NOTE: use tex2nix
    #nixos-cn.re-export.telegram-send
    #nixos-cn.dingtalk
  ];

  nix.registry.hsz = {
    from = { type = "indirect"; id = "hsz"; };
    to = { type = "gitlab"; owner = "highsunz"; repo = "flames"; };
  };

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
    git = callWithHelpers ./parts/git.nix {};
    ssh = callWithHelpers ./parts/ssh.nix {};
    readline = {
      enable = true;
      variables = {
        editing-mode = "vi";
        completion-ignore-case = "On";
      };
    };
    neovim = callWithHelpers ./parts/neovim {};
    bat = {
      enable = true;
      config = {
        theme = "Nord";
        style = "numbers,changes,header-filename,header-filesize";
      };
    };
    starship = callWithHelpers ./parts/starship.nix {};
    bash = { enable = true; };
    zsh = {
      enable = true;
      initExtraFirst = ''
        typeset -T INFOPATH infopath
        typeset -U PATH MANPATH INFOPATH
        # test variable is set, REF: <https://stackoverflow.com/a/42655305/13482274>
        if [[ -z "''${__tested_os_release+1}" ]]; then
          source /etc/os-release
          [[ "NixOS" == "$NAME" ]] || source <(sed -Ee '/exec/d' $(which nixGLIntel))
          export __tested_os_release=1
        fi
        if [[ -o interactive ]]; then
          if [[ -z "$noexecfish" ]]; then
            exec fish
          fi
        fi
      '';
    };
    fzf = {
      enable = true;
      defaultOptions = [
        "--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD"
        "--color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96"
        "--color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
      ];
      tmux.enableShellIntegration = true;
    };
    fish = callWithHelpers ./parts/fish {};
    tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 100000;
      sensibleOnTop = true;
      plugins = [{
        plugin = pkgs.tmux-plugin-catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'mocha'";
      }] ++ (with pkgs.tmuxPlugins; [
        better-mouse-mode
        extrakto
      ]);
      extraConfig = builtins.readFile ./parts/raw/tmux.conf;
    };
    zellij = {
      enable = true;
      package = pkgs.zellij-hirr;
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    LS_COLORS = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:";
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
    SKIM_DEFAULT_OPTS = toString config.programs.fzf.defaultOptions;
  } // (if proxy != null then {
    http_proxy = "http://${proxy.addr}:${proxy.port}";
    https_proxy = "http://${proxy.addr}:${proxy.port}";
  } else {});
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
    condarc = {
      source = ./parts/raw/condarc.yaml;
      target = ".condarc";
    };
  };

  xdg = with helpers; {
    enable = true;
    configFile = with builtins; {
      "wakatime/.wakatime.cfg".text = readFile ./parts/raw/wakatime;
      "gdb/gdbinit".source = "${pkgs.gdb-dashboard}/share/gdb-dashboard/gdbinit";
      "fish/themes/catppuccin.theme".source = "${pkgs.fish-plugin-catppuccin}/share/fish/tools/web_config/themes/Catppuccin Mocha.theme";
    } // (manifestXdgConfigFilesFrom ./parts/mirrored);
  };

  systemd.user.startServices = true;

  # So that fish can complete `man` commands
  programs.man.generateCaches = true;
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
  wayland.windowManager.sway = callWithHelpers ./parts/sway.nix {};
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
    libnotify
    logseq
    meshlab
    nixGLIntel
    tdesktop-megumifox
    wl-clipboard  # Need to be globally executable for clipboard integrations to work
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
    fish.shellAliases.meshlab = with pkgs;
      "QT_QPA_PLATFORM=xcb ${sdwrap}/bin/sdwrap ${meshlab}/bin/meshlab";
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
      settings = callWithHelpers ./parts/alacritty.nix {};
    };

    firefox = callWithHelpers ./parts/firefox.nix {};

    waybar = {
      settings = callWithHelpers ./parts/waybar {};
      style = callWithHelpers ./parts/waybar/style.css.nix {};
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

  xdg = {
    enable = true;
    systemDirs.data = [
      "${myHome}/.nix-profile/share"
    ];
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
        "video/x-matroska" = "mpv.desktop";
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
    services.waybar.Unit.PartOf = [ "tray.target" ];
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
    dunst = rec {
      enable = true;
      iconTheme = {
        name = "Flat-Remix-Yellow-Dark";
        package = pkgs.flat-remix-icon-theme-proper-trayicons;
      };
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
} else {})
]
