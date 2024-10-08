{ inputs, lib, pkgs, config
, hostName, myName, myHome
, headless
, proxy
, helpers, __callWithHelpers
, ...
}: let
  callWithHelpers = f: override: __callWithHelpers f (override // { inherit config callWithHelpers; });
in {
  home.username = myName;
  home.homeDirectory = myHome;
  ricing.theme = "dark";
  programs.supervisedDesktopEntries.enable = true;
  home = {
    packages = with pkgs; [
      btop
      comma
      coreutils-full
      dmidecode
      dnsutils
      dogdns
      dufs
      dysk
      eza
      fd
      gdu
      git
      gnugrep
      gnused
      gnutar
      home-manager
      htop
      hyperfine
      iotop
      iproute2
      iputils
      jq
      killall
      less
      libqalculate
      ncurses
      nixStable
      ollama
      p7zip
      procps
      procs
      progress
      ripgrep
      sdwrap
      telegram-send
      tinytools
      unar
      unzip
      util-linux
      viddy
      waypipe
      wget
      xdg-open-handlr
      yq  # yq, tomlq
      zip
      zstd
    ]
    ++ (lib.optional (pkgs.config.cudaSupport) python3Packages.gpustat);
  };

  nix.gc.automatic = true;
  nix.registry = {
    pkgs.flake = inputs.nixpkgs;
    nixgl.flake = inputs.nixgl;
    hsz = {
      from = { type = "indirect"; id = "hsz"; };
      to = { type = "git"; url = "https://ash.radicle.garden/rad:z3L8Nyj3A2eAyvqbLsw1S27T88wai"; };
    };
  };
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.stateHome}/gnupg";
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [{
      source = ../raw/gnupg/ff02f82f94915004.gpg;
      trust = 5;
    }];
    settings = {
      keyserver = "hkps://keyserver.ubuntu.com";
      keyserver-options = [
        "timeout=10"
        "import-clean"
        "no-self-sigs-only"
      ];
      no-greeting = true;
      no-permission-warning = true;
      lock-never = true;
      no-autostart = lib.mkDefault headless;
    };
  };

  programs = {
    git = callWithHelpers ../git.nix {};
    ssh = callWithHelpers ../ssh.nix {};
    readline = {
      enable = true;
      variables = {
        editing-mode = "vi";
        completion-ignore-case = "On";
      };
    };
    neovim = callWithHelpers ../neovim {};
    bat = {
      enable = true;
      config = {
        theme = "catppuccin";
        style = "numbers,changes,header-filename,header-filesize";
      };
    };
    starship = callWithHelpers ../starship.nix {};
    bash = {
      enable = true;
      initExtra = ''
        if [[ -z "''${noexecfish+1}"
           && "$-" == *i*
           && (-e "/run/host/container-manager" || -e "/.dockerenv")
           && -d /sbin
           ]]; then
          echo "Executing fish from bash because all of the following are true:"
          echo "  1) the environment variable 'noexecfish' is not set"
          echo "  2) this is an interactive shell"
          echo "  3) we are inside a container"
          echo "  4) the container has FHS"
          exec fish
        fi
      '';
    };
    zsh = {
      enable = true;
      initExtraFirst = ''
        typeset -T INFOPATH infopath
        typeset -U PATH MANPATH INFOPATH
      '';
      initExtra = ''
        if [[ -o interactive
           && -z "''${noexecfish+1}" ]]; then
          exec fish
        fi
      '';
      envExtra = ''
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
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
    fish = callWithHelpers ../fish {};
    tmux = {
      enable = true;
      escapeTime = 0;
      prefix = "C-s";
      keyMode = "vi";
      clock24 = true;
      historyLimit = 100000;
      sensibleOnTop = true;
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        extrakto
      ];
      extraConfig = builtins.readFile ../raw/tmux.conf;
    };
    zellij = {
      enable = false;
      package = pkgs.zellij-hirr;
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    LS_COLORS = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:";
    CMAKE_EXPORT_COMPILE_COMMANDS = 1;  # cmake 3.17+
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
    ELM_HOME = "${config.xdg.stateHome}/elm";
    PAGER = "less";
    PARALLEL_HOME = "${config.xdg.stateHome}/parallel";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    MDCAT_PAGER = "less";
    PYTHONDONTWRITEBYTECODE = 1;
    PYTHONUNBUFFERED = 1;
    PYTHONBREAKPOINT = "ipdb.set_trace";  # NOTE: use `breakpoint()` in script to trigger debugger
    PIP_REQUIRE_VIRTUALENV = 1;
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    SKIM_DEFAULT_OPTS = toString config.programs.fzf.defaultOptions;
  } // (lib.optionalAttrs (proxy != null) {
    inherit ((proxy.envVarsFor hostName).http) all_proxy http_proxy https_proxy ftp_proxy rsync_proxy;
    inherit (proxy.envVarsFor hostName) no_proxy;
  }) // (lib.optionalAttrs (config.home.username != "root") {
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
  });
  pam.sessionVariables = config.home.sessionVariables;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-lua
      fcitx5-rime
    ];  # other addons are added only for headful profiles
  };

  home.file = {
    ipythonConfig = {
      text = ''
        c.TerminalInteractiveShell.editing_mode = "vi"
        c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
      '';
      target = ".ipython/profile_default/ipython_config.py";
    };
    ipythonAutoImport = {
      text = ''
        from collections import defaultdict
        from concurrent.futures import ThreadPoolExecutor
        from dataclasses import asdict, dataclass
        import functools
        import gc
        from importlib import reload
        import itertools
        import json
        from pathlib import Path
        import random
      '';
      target = ".ipython/profile_default/startup/00-autoimport.py";
    };
    condarc = {
      source = ../raw/condarc.yaml;
      target = ".condarc";
    };
    gduConfig = {
      source = ../raw/gdu.yaml;
      target = ".gdu.yaml";
    };
    suppressGnuParallelCitationAlert = {
      text = "";
      target = "${config.home.sessionVariables.PARALLEL_HOME or ".parallel"}/will-cite";
    };
  } // (if proxy == null
  then {}
  else {
    npmConfig = {
      text = callWithHelpers ../raw/npmrc.nix {};
      target = ".npmrc";
    };
  });

  xdg = with helpers; {
    enable = true;
    configFile = with builtins; {
      "gdb/gdbinit".source = "${pkgs.gdb-dashboard}/share/gdb-dashboard/gdbinit";
      "fish/themes/Catppuccin Latte.theme".source = "${pkgs.fish-plugin-catppuccin}/share/fish/tools/web_config/themes/Catppuccin Latte.theme";
      "fish/themes/Catppuccin Mocha.theme".source = "${pkgs.fish-plugin-catppuccin}/share/fish/tools/web_config/themes/Catppuccin Mocha.theme";
      "xkb" = {
        source = "${pkgs.xkb-layouts}/share/X11/xkb";
        recursive = true;
      };
    } // (manifestXdgConfigFilesFrom { inherit config; pathPrefix = ../mirrored/headless; });
    mimeApps = {
      enable = true;
      defaultApplications = builtins.mapAttrs (_: app: let
        sde = config.programs.supervisedDesktopEntries;
      in if sde.enable then "${sde.mark}-${app}" else app) {
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
        "image/*" = "feh.desktop";
      };
    };
  };

  systemd.user = lib.mkIf (!config.home.presets.sans-systemd) {
    sessionVariables = builtins.mapAttrs
      (name: value: lib.mkDefault value)
      config.home.sessionVariables;
    startServices = true;
    targets.xdg-desktop-autostart.Install.WantedBy = [ "default.target" ];
    services.create-gpg-socketdir = {
      Service = {
        ExecStart = "${config.programs.gpg.package}/bin/gpgconf --create-socketdir";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
    services.fcitx5-daemon.Service.ExecStart = lib.mkForce "${config.i18n.inputMethod.package}/bin/fcitx5 --replace";
  };

  # So that fish can complete `man` commands
  programs.man.generateCaches = true;
}
