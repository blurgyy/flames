{ inputs, lib, pkgs, config
, name, myName, myHome
, headless
, proxy
, helpers, __callWithHelpers
, ...
}: let
  callWithHelpers = f: override: __callWithHelpers f (override // { inherit config callWithHelpers; });
in {
  home.username = myName;
  home.homeDirectory = myHome;
  ricing.textual.theme = "dark";
  programs.supervisedDesktopEntries.enable = true;
  home.packages = with pkgs; [
    bat
    btop
    cachix
    clang-tools
    colmena
    conda
    dogdns
    dufs
    exa
    exiftool
    fd
    file
    fish
    fzf
    gdb
    gdu
    git
    git-sync
    glow
    gnutar
    hexyl
    home-manager
    htop
    hydra-check
    hyperfine
    inotify-tools
    imagemagick
    iotop
    jq
    less
    lfs
    libime-history-merge
    libqalculate
    lnav
    lsof
    nix-output-monitor
    nvfetcher
    parallel
    patchelf
    pciutils
    procs
    q-text-as-data
    ripgrep
    sdwrap
    sops
    strace
    telegram-send
    tex2nix
    tinytools
    tokei
    unar
    unzip
    util-linux
    viddy
    waypipe
    wget
    xdg-open-handlr
    yt-dlp
    zip
    zstd
    #texlive.combined.scheme-full  # NOTE: use tex2nix
    #nixos-cn.dingtalk
  ];

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    hsz = {
      from = { type = "indirect"; id = "hsz"; };
      to = { type = "gitlab"; owner = "highsunz"; repo = "flames"; };
    };
    adrivems = {
      from = { type = "indirect"; id = "adrivems"; };
      to = { type = "gitlab"; owner = "highsunz"; repo = "aliyundrive-mediaserver"; };
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.stateHome}/gnupg";
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [{
      source = ./parts/raw/gnupg/ff02f82f94915004.gpg;
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
      no-autostart = headless;
    };
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
        theme = "catppuccin";
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

      ${lib.optionalString (pkgs.stdenv.hostPlatform.system == "x86_64-linux") ''
        # test variable is set, REF: <https://stackoverflow.com/a/42655305/13482274>
        if [[ -z "''${__tested_os_release+1}" ]]; then
          source /etc/os-release
          [[ "NixOS" == "$NAME" ]] || {
            source <(sed -Ee '/exec/d' ${pkgs.nixGLIntel}/bin/nixGLIntel)
            systemctl --user import-environment $(grep -E 'export \w+=' ${pkgs.nixGLIntel}/bin/nixGLIntel | cut -d= -f1 | cut -d' ' -f2)
          }
          export __tested_os_release=1
        fi
      ''}

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
    fish = callWithHelpers ./parts/fish {};
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
      extraConfig = builtins.readFile ./parts/raw/tmux.conf;
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
    MANPAGER = "less";
    MDCAT_PAGER = "less";
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
    PYTHONDONTWRITEBYTECODE = 1;
    PYTHONUNBUFFERED = 1;
    PYTHONBREAKPOINT = "pudb.set_trace";  # NOTE: use `breakpoint()` in script to trigger debugger
    PIP_REQUIRE_VIRTUALENV = 1;
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    SKIM_DEFAULT_OPTS = toString config.programs.fzf.defaultOptions;
  } // (if proxy != null then {
    http_proxy = "http://${proxy.addr}:${proxy.port}";
    https_proxy = "http://${proxy.addr}:${proxy.port}";
  } else {});
  systemd.user.sessionVariables = config.home.sessionVariables;
  pam.sessionVariables = config.home.sessionVariables;

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

  home.file = {
    ipythonConfig = {
      text = ''
        c.TerminalInteractiveShell.editing_mode = "vi"
        c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
      '';
      target = ".ipython/profile_default/ipython_config.py";
    };
    condarc = {
      source = ./parts/raw/condarc.yaml;
      target = ".condarc";
    };
    gduConfig = {
      source = ./parts/raw/gdu.yaml;
      target = ".gdu.yaml";
    };
  };

  xdg = with helpers; {
    enable = true;
    configFile = with builtins; {
      "wakatime/.wakatime.cfg".text = readFile ./parts/raw/wakatime;
      "gdb/gdbinit".source = "${pkgs.gdb-dashboard}/share/gdb-dashboard/gdbinit";
      "fish/themes/Catppuccin Latte.theme".source = "${pkgs.fish-plugin-catppuccin}/share/fish/tools/web_config/themes/Catppuccin Latte.theme";
      "fish/themes/Catppuccin Mocha.theme".source = "${pkgs.fish-plugin-catppuccin}/share/fish/tools/web_config/themes/Catppuccin Mocha.theme";
    } // (manifestXdgConfigFilesFrom { inherit config; pathPrefix = ./parts/mirrored/headless; });
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
        "image/*" = "imv-folder.desktop";
      };
    };
  };

  systemd.user = {
    startServices = true;
    targets.xdg-desktop-autostart.Install.WantedBy = [ "default.target" ];
    services.create-gpg-socketdir = {
      Service = {
        ExecStart = "${config.programs.gpg.package}/bin/gpgconf --create-socketdir";
        RemainAfterExit = true;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  # So that fish can complete `man` commands
  programs.man.generateCaches = true;
}
