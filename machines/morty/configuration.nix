{ config, lib, pkgs, home-manager, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.gy = import ./home/gy {
      inherit pkgs lib config;
      hm-config = config.home-manager.users.gy;
    };
  };

  nix = {
    autoOptimiseStore = true;
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "gy" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "vscode-codicons"
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.kernelModules = [ "i915" "amdgpu" ];
    kernel = {
      sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "dev.i915.perf_stream_paranoid" = 0;
        "kernel.sysrq" = 1;
        "vm.swappiness" = 1;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 80;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "loglevel=3"
      "pcie_aspm=off"
      "mitigations=off"
      "resume=LABEL=nixos-swap"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  networking = {
    hostName = "morty";
    useNetworkd = true;
    interfaces.wlo1.useDHCP = true;
    wireless = {
      enable = true;
      networks = {  # More network configs go in ./sops.nix
        "ZJUWLAN".authProtocols = [ "NONE" ];
        "ZJUWLAN-NEW".authProtocols = [ "NONE" ];
      };
    };
    firewall.enable = false;
    # REF: man:resolvconf.conf(5)
    resolvconf.extraConfig = "name_servers=127.0.0.53";
  };
  services = {
    resolved.enable = false;
  };

  systemd = {
    extraConfig = "DefaultTimeoutStopSec=16s";
    network.wait-online = {
      anyInterface = true;
      timeout = 16;
    };
  };

  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i24b";
    # keyMap = "us";
    # NOTE: Below option (useXkbConfig) conflicts with above option (keyMap)
    useXkbConfig = true;  # idk what this does: use xkbOptions in tty.
    packages = with pkgs; [ terminus_font ];
  };

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    light.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    # systemd complains about 226/NAMESPACE when starting bluetooth.service
    bluetooth.enable = true;
    opengl = {
      # NOTE: needed to get sway to work.  (See https://search.nixos.org)
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
      ];
    };
  };

  # Enable pipewire (see NixOS Wiki)
  security.rtkit.enable = true;
  security.pam.services.swaylock = { };
  security.sudo.extraRules = let
    applyNoPasswd = cmd: { command = cmd; options = [ "NOPASSWD" ]; };
    systemdCmds = map applyNoPasswd (map (cmd: "${pkgs.systemd}/bin/${cmd}") [ "systemctl" "journalctl" ]);
  in [
    { groups = [ "wheel" ]; commands = systemdCmds; }
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [
        "/"
        "/elements"
      ];
    };
    fstrim.enable = true;

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    logind.lidSwitch = "ignore";
    # logind.killUserProcess = false;  # This is already the default
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      media-session.enable = false;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
    groups.plocate = { };  # for plocate-updatedb.service
    users.gy = {
      isNormalUser = true;
      extraGroups = [
        config.users.groups.wheel.name
        config.users.groups.video.name
        config.users.groups.plocate.name
        ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKco1z3uNTuYW7eVl2MTPrvVG5jnEnNJne/Us+LhKOwC gy@rpi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4yanex/42s/F9dP7CJ3BstzEC7n0qwi0+2hhxOAS6 gy@hooper"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdK4KWp4YMiDfq+hLZ3fQQ+02XnYhLY47l7Zro+xKud gy@watson"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYfrTPDWGRcxfnmDU88HLoDrWekz+yTZHk68/75FtDX gy@Blurgy"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlMIWDojT8L4g7g0z6uC2EhALHr2fL/ZIdNnNiyggBj gy@HUAWEI"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1LWYTkOiaY/TSs9qoAAQm2tVHw4Lljz90pCREnW2Zx gy@FridaY"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlA0ON/HBEhGPo1Uu5lrgpbQ/D/Ivd7q3LuNTXScrRi gy@john"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1m/+k7RnoL1YVbP4vv8XTFnlP6CGmnXJfxA+Xu6H5q gy@morty"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    libnotify
    neovim
    zsh fish fzf
    exa bat fd ripgrep procs dua
    htop
    file
    zip unzip unar
    plocate
    jq libqalculate
    sops age
    hydra-check
    wine-wayland
  ];
  environment.variables = {
    EDITOR = "nvim";
    LS_COLORS = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:";
  };
  environment.etc."nbfc/nbfc.json" = {
    text = ''{"SelectedConfigId": "HP Omen 15-dc00xxxx", "TargetFanSpeeds": [-1]}'';
    mode = "0644";
  };
  systemd = {
    packages = with pkgs; [ plocate ];
    services = {
      nbfc-linux = with pkgs; {
        enable = true;
        description = "NoteBook FanControl service";
        path = [ kmod nbfc-linux ];
        preStart = "${nbfc-linux}/bin/nbfc wait-for-hwmon";
        script = "${nbfc-linux}/bin/nbfc start";
        preStop = "${nbfc-linux}/bin/nbfc stop";
        serviceConfig = {
          Type = "forking";
          PIDFile = /run/nbfc_service.pid;
          TimeoutStopSec = 20;
          Restart = "on-failure";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  fonts = let
    fontConfsRoot = ./parts/raw/fontconfig;
  in {
    enableDefaultFonts = false;
    fontconfig = {
      enable = true;
      defaultFonts = let
        generic-fallbacks = [
          "emoji"
          "codicon"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "Font Awesome 5 Free"
          "Font Awesome 5 Brands"
          "Symbols Nerd Font"
        ];
      in {
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK HK"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
          "LXGW Wenkai"
        ] ++ generic-fallbacks;
        # NOTE: "HarmonyOS Sans" won't work.  Use "HarmonyOS Sans SC", etc.
        sansSerif = [
          "Rubik"
          "HarmonyOS Sans SC"
          "HarmonyOS Sans TC"
          "LXGW Wenkai"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK HK"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
        ] ++ generic-fallbacks;
        monospace = [
          "Iosevka Fixed"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
          "Noto Sans Mono CJK HK"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
        ] ++ generic-fallbacks;
        emoji = [ "Apple Color Emoji" ];
      };
      # includeUserConf = true;
      localConf = with builtins;
        ''<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE fontconfig SYSTEM "url:fontconfig:fonts.dtd">
        <fontconfig>
        '' +
        concatStringsSep "\n" (
          map (f: readFile "${fontConfsRoot}/${f}") (
            attrNames (readDir fontConfsRoot)
          )
        ) +
        "</fontconfig>";
    };
    fonts = with pkgs; [
      rubik
      (iosevka-bin.override { variant = "sgr-iosevka-fixed"; })
      (iosevka-bin.override { variant = "sgr-iosevka-slab"; })
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      lxgw-wenkai

      harmonyos-sans
      symbols-nerd-font
      vscode-codicons
      apple-color-emoji
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "prohibit-password";  # NOTE: This is NixOS default
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # needed for opening filechooser
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
