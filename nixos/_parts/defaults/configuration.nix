{ config, lib, pkgs, inputs, ... }: let
  keys = import ./public-keys.nix;
in {
  users = {
    groups.plocate = {};  # for plocate-updatedb.service
    users = {
      root.openssh.authorizedKeys.keys = keys.users;
      gy = {
        openssh.authorizedKeys.keys = keys.users;
        extraGroups = [
          config.users.groups.keys.name 
          config.users.groups.wheel.name
          config.users.groups.video.name
          config.users.groups.plocate.name
          config.users.groups.dialout.name
        ];
        shell = pkgs.zsh;
      };
    };
  };

  nix = {
    nrBuildUsers = 0;
    package = lib.mkDefault pkgs.nixUnstable;
    registry = {
      pkgs.flake = inputs.nixpkgs;
      nixgl.flake = inputs.nixgl;
      hsz = {
        from = { type = "indirect"; id = "hsz"; };
        to = { type = "gitlab"; owner = "highsunz"; repo = "flames"; };
      };
      adrivems = {
        from = { type = "indirect"; id = "adrivems"; };
        to = { type = "gitlab"; owner = "highsunz"; repo = "aliyundrive-mediaserver"; };
      };
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" "auto-allocate-uids" "cgroups" ];
      auto-allocate-uids = true;
      use-cgroups = true;
      trusted-users = [ "root" "gy" ];
      substituters = (lib.optional (config.time.timeZone == "Asia/Shanghai") "https://mirrors.bfsu.edu.cn/nix-channels/store") ++ [
        "https://nixos-cn.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.blurgy.xyz"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.blurgy.xyz:Xg9PvXkUIAhDIsdn/NOUUFo+HHc8htSiGj7O6fUj/W4="
      ];
      auto-optimise-store = true;
      # REF: <https://docs.cachix.org/faq#frequently-asked-questions>
      # REF: <https://nix.dev/faq#how-do-i-force-nix-to-re-check-whether-something-exists-at-a-binary-cache>
      narinfo-cache-negative-ttl = 30;
      tarball-ttl = 30;
    };
    gc = {
      automatic = true;
      dates = "Sat *-*-* 03:15:00";
      randomizedDelaySec = "3h45min";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  networking = {
    domain = "blurgy.xyz";
    useNetworkd = lib.mkDefault true;
    interfaces = {
      eth0.useDHCP = lib.mkDefault true;
      wlo1.useDHCP = lib.mkDefault true;
      wlan0.useDHCP = lib.mkDefault true;
    };
    firewall.enable = lib.mkDefault false;
    hosts = {
      "81.69.28.75" = [
        "peterpan.${config.networking.domain}"
        "pp.${config.networking.domain}"
        "soft-serve"
        "softserve"
      ];
      "10.50.200.245" = [ "net.zju.edu.cn" ];
      "10.50.200.3" = [ "net2.zju.edu.cn" ];
    };
  };
  services.resolved = let
    dnsServers = [ "1.0.0.1" "1.1.1.1" "8.8.4.4" "8.8.8.8" ];
  in {
    enable = lib.mkDefault true;
    dnssec = lib.mkDefault "false";
    fallbackDns = lib.mkDefault dnsServers;
    extraConfig = ''
      DNS=${toString dnsServers}
    '';
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=16s";
    network.wait-online = {
      anyInterface = lib.mkDefault false;
      # WARN: explicitly set this with e.g. [ "--interface=wlan0" "--interface=eth0" ] for each machine.
      extraArgs = lib.mkDefault null;
      timeout = 16;
    };
    services.systemd-rfkill.serviceConfig.ExecStartPost = "${pkgs.util-linux}/bin/rfkill unblock all";
    tmpfiles.rules = [
      "d /.btrbk/snapshots 0700 root root - -"
      "f /var/lib/systemd/linger/gy 0644 root root - -"
    ];
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = lib.mkDefault "C.UTF-8";
    supportedLocales = lib.mkDefault [
      "${config.i18n.defaultLocale}/UTF-8"
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";
  console.useXkbConfig = true;

  console = {
    font = "ter-i24b";
    packages = with pkgs; [ terminus_font ];
  };

  programs = {
    command-not-found.enable = lib.mkDefault false;
    dconf.enable = lib.mkDefault true;
    fuse.userAllowOther = lib.mkDefault true;
  };

  security.sudo.extraRules = let
    applyNoPasswd = cmd: { command = cmd; options = [ "NOPASSWD" ]; };
    systemdCmds = map applyNoPasswd (map (cmd: "${pkgs.systemd}/bin/${cmd}") [ "systemctl" "journalctl" ]);
  in [
    { groups = [ "wheel" ]; commands = systemdCmds; }
  ];

  services = {
    udisks2.enable = lib.mkForce true;
    btrfs.autoScrub = {
      enable = lib.mkDefault (with builtins;
        any
          (fs: fs.fsType == "btrfs")
          (attrValues config.fileSystems));
      interval = "monthly";
      fileSystems = with builtins;
        attrNames
          (lib.filterAttrs
            (mountPoint: fs: fs.fsType == "btrfs")
            config.fileSystems);
    };
    fstrim.enable = true;

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    logind.killUserProcesses = false;  # This is already the default
  };

  # Add necessary paths to environment.pathsToLink to enable fish completion and generates man-db
  # cache.
  programs.fish.enable = true;
  # Similar for zsh.
  programs.zsh.enable = true;

  programs.supervisedDesktopEntries.enable = true;
  environment.systemPackages = with pkgs; [
    age
    bat
    colmena
    dogdns
    dufs
    exa
    fd
    ffmpeg-full
    file
    fish
    fzf
    gcc
    gdu
    git
    glow
    hexyl
    home-manager
    htop
    hyperfine
    inotify-tools
    iotop
    jq
    libqalculate
    lm_sensors
    lsof
    neovim
    nix-output-monitor
    pciutils
    procs
    ripgrep
    sdwrap
    sops
    sqlite
    sshfs
    strace
    tokei
    unar
    unzip
    zip
    zsh
    (python3.withPackages (p: with p; [
      click
      h5py
      icecream
      ipdb
      ipython
      matplotlib
      numpy
      pillow
      plyfile
      tqdm
    ]))
    hydra-check cachix
    xdg-utils
  ];

  environment.variables = {
    EDITOR = "nvim";
    LS_COLORS = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:";
    PIP_REQUIRE_VIRTUALENV = "1";
  };

  # Enabling this causes massive rebuilds and is poorly supported.
  # related: <https://github.com/NixOS/nixpkgs/issues/179938#issuecomment-1173705936>
  environment.noXlibs = lib.mkForce false;

  services = {
    locate = {
      enable = true;
      locate = pkgs.plocate;
      # mlocate and plocate do not support the services.locate.localuser option. updatedb will run
      # as root.  Silence this warning by setting services.locate.localuser = null
      localuser = null;
    };
    openssh = {
      enable = true;  # NOTE: OpenSSH is disabled by default!
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        #PermitRootLogin = "prohibit-password";  # NOTE: This is NixOS default
        X11Forwarding = lib.mkDefault (!config.environment.noXlibs);
        StreamLocalBindUnlink = lib.mkDefault true;
        ClientAliveCountMax = 3;
        ClientAliveInterval = 5;
      };
      knownHosts = let
        mkHost = name: aliases: {
          publicKey = keys.hosts.${name};
          extraHostNames = aliases;
        };
        mkHosts = hostDefs: lib.mapAttrs mkHost hostDefs;
      in mkHosts {
        cindy = [ "cindy" "hydra" "cache" ];
        cube = [ "cube" ];
        peterpan = [ "peterpan" ];
        trigo = [ "trigo" ];
        rubik = [ "rubik" ];
        quad = [ "quad" ];
        morty = [];
        opi = [];
        rpi = [];
      } // (with keys.services; {
        soft-serve.publicKey = soft-serve;
      });
    };
  };
}
