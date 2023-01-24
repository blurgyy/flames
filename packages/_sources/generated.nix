# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  adobe-flash-player = {
    pname = "adobe-flash-player";
    version = "20220331041116";
    src = fetchurl {
      url = "http://web.archive.org/web/20220331041116/https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz";
      sha256 = "sha256-iD96ojMB/IDeh5UBFXUzpKzb/uByHtfFdnbcAy/flsM=";
    };
  };
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "ios-15.4";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-15.4/AppleColorEmoji.ttf";
      sha256 = "sha256-CDmtLCzlytCZyMBDoMrdvs3ScHkMipuiXoNfc6bfimw=";
    };
  };
  dt = {
    pname = "dt";
    version = "v0.7.10";
    src = fetchFromGitHub ({
      owner = "blurgyy";
      repo = "dt";
      rev = "v0.7.10";
      fetchSubmodules = false;
      sha256 = "sha256-guTqOmrJLow84jUG6po6nfSFGFGEIdj6nf5Rm3GcLOg=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./dt-v0.7.10/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  fcitx5-fluent-dark-theme = {
    pname = "fcitx5-fluent-dark-theme";
    version = "77556203063760d87b87fb0b3b82f14cbe190193";
    src = fetchFromGitHub ({
      owner = "Reverier-Xu";
      repo = "FluentDark-fcitx5";
      rev = "77556203063760d87b87fb0b3b82f14cbe190193";
      fetchSubmodules = false;
      sha256 = "sha256-om3jI6XNpkmFBXarwROKb6ldvCKaKzrBkLAdPmCxWkU=";
    });
    date = "2022-05-26";
  };
  fcitx5-sogou-themes = {
    pname = "fcitx5-sogou-themes";
    version = "fbc1e34179cb6a37f0ddb28024f9bf94f0cbd70d";
    src = fetchFromGitHub ({
      owner = "sxqsfun";
      repo = "fcitx5-sogou-themes";
      rev = "fbc1e34179cb6a37f0ddb28024f9bf94f0cbd70d";
      fetchSubmodules = false;
      sha256 = "sha256-+Q8VNtAFWWD0UbF9nN+7FsCpcwUIi7HFJRbTeHU3HLo=";
    });
    date = "2021-08-26";
  };
  fish-plugin-catppuccin = {
    pname = "fish-plugin-catppuccin";
    version = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "fish";
      rev = "b90966686068b5ebc9f80e5b90fdf8c02ee7a0ba";
      fetchSubmodules = false;
      sha256 = "sha256-wQlYQyqklU/79K2OXRZXg5LvuIugK7vhHgpahpLFaOw=";
    });
    date = "2022-12-29";
  };
  fish-plugin-tide = {
    pname = "fish-plugin-tide";
    version = "v5.5.1";
    src = fetchFromGitHub ({
      owner = "IlanCosman";
      repo = "tide";
      rev = "v5.5.1";
      fetchSubmodules = false;
      sha256 = "sha256-vi4sYoI366FkIonXDlf/eE2Pyjq7E/kOKBrQS+LtE+M=";
    });
  };
  gdb-dashboard = {
    pname = "gdb-dashboard";
    version = "v0.16.0";
    src = fetchFromGitHub ({
      owner = "cyrus-and";
      repo = "gdb-dashboard";
      rev = "v0.16.0";
      fetchSubmodules = false;
      sha256 = "sha256-sk638bMM96Nuv+tcNsJANhj6EOaqjN8CRmG8kvFEceY=";
    });
  };
  gsfonts = {
    pname = "gsfonts";
    version = "20200910";
    src = fetchFromGitHub ({
      owner = "ArtifexSoftware";
      repo = "urw-base35-fonts";
      rev = "20200910";
      fetchSubmodules = false;
      sha256 = "sha256-YQl5IDtodcbTV3D6vtJi7CwxVtHHl58fG6qCAoSaP4U=";
    });
  };
  harmonyos-sans = {
    pname = "harmonyos-sans";
    version = "0d79cad76b37ba0f3ccb1323c83833c78e0860de";
    src = fetchgit {
      url = "https://gitee.com/openharmony/resources";
      rev = "0d79cad76b37ba0f3ccb1323c83833c78e0860de";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-0jIaSp3WJ9jiTFS9nhwUo27N8WWne/yW9Y8vQ+sgHoI=";
    };
    date = "2022-05-28";
  };
  import-ply-as-verts-for-blender = {
    pname = "import-ply-as-verts-for-blender";
    version = "v2.1";
    src = fetchFromGitHub ({
      owner = "TombstoneTumbleweedArt";
      repo = "import-ply-as-verts";
      rev = "v2.1";
      fetchSubmodules = false;
      sha256 = "sha256-uH0PADYv2hbDxPSuS5ckuov9mJ8pYuWt8hp18rXll6Y=";
    });
  };
  libime-history-merge = {
    pname = "libime-history-merge";
    version = "v0.3.0";
    src = fetchFromGitHub ({
      owner = "blurgyy";
      repo = "libime-history-merge";
      rev = "v0.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-aq8wRW+YFNNM1y6QzZzJDpisMJieURXjbKVoiRgtryE=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./libime-history-merge-v0.3.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  loyalsoldier-geoip = {
    pname = "loyalsoldier-geoip";
    version = "202301232209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202301232209/geoip.dat";
      sha256 = "sha256-TQsBuL/+frPkv1Wsnj0PeYLwXOPNuStIWgvUi8hgxI4=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202301232209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202301232209/geosite.dat";
      sha256 = "sha256-Iybs7DKxj3PYbHqZ5Dq4fO3R9fZK8oY342JThRk9mOw=";
    };
  };
  luarock-dbus_proxy = {
    pname = "luarock-dbus_proxy";
    version = "v0.10.3";
    src = fetchFromGitHub ({
      owner = "stefano-m";
      repo = "lua-dbus_proxy";
      rev = "v0.10.3";
      fetchSubmodules = false;
      sha256 = "sha256-Yd8TN/vKiqX7NOZyy8OwOnreWS5gdyVMTAjFqoAuces=";
    });
  };
  nftables-geoip-db = {
    pname = "nftables-geoip-db";
    version = "2023-01";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2023-01.csv.gz";
      sha256 = "sha256-P5v+IX0PD2gI/dsWskCn+TUFb3P60izWpX7j1Q0MOLU=";
    };
  };
  rssbot = {
    pname = "rssbot";
    version = "v2.0.0-alpha.11";
    src = fetchFromGitHub ({
      owner = "iovxw";
      repo = "rssbot";
      rev = "v2.0.0-alpha.11";
      fetchSubmodules = false;
      sha256 = "sha256-gNCjphzJWGjdRsyytjp1l1eYqPYI3S+kpZJ/BpJl7ac=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./rssbot-v2.0.0-alpha.11/Cargo.lock;
      outputHashes = {
        "tbot-0.6.7" = "sha256-gPfwPPJEYcgETvUlT9VGNOVKp19vKHu0sEuMiHaxWKs=";
      };
    };
  };
  rustdesk-server = {
    pname = "rustdesk-server";
    version = "1.1.7";
    src = fetchFromGitHub ({
      owner = "rustdesk";
      repo = "rustdesk-server";
      rev = "1.1.7";
      fetchSubmodules = false;
      sha256 = "sha256-bPb9LQxQdo+SgEwW5nZcJD6FVW0+DN3Zymuaa21CfAU=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./rustdesk-server-1.1.7/Cargo.lock;
      outputHashes = {
        "confy-0.4.0" = "sha256-e91cvEixhpPzIthAxzTa3fDY6eCsHUy/eZQAqs7QTDo=";
        "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
        "tokio-socks-0.5.1" = "sha256-inmAJk0fAlsVNIwfD/M+htwIdQHwGSTRrEy6N/mspMI=";
      };
    };
  };
  simple-icons = {
    pname = "simple-icons";
    version = "8.3.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/8.3.0/simple-icons-font-8.3.0.zip";
      sha256 = "sha256-xzVbd4E8blaiQMJ3vom7Tqkews2wGrXDYmMdMoXlxBE=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v2.3.2";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.2/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-E3+Z0LdaM9I/L7783Hd/WOAUocH9XTVeFWrzmEt0AjA=";
    };
  };
  telegram-send = {
    pname = "telegram-send";
    version = "0.34";
    src = fetchurl {
      url = "https://pypi.io/packages/source/t/telegram-send/telegram-send-0.34.tar.gz";
      sha256 = "sha256-KR9mU8FvA+vOz4FCIljrFk9XCNthC8d55of5Pta/oyQ=";
    };
  };
  tinytools = {
    pname = "tinytools";
    version = "v1.1.2";
    src = fetchFromGitHub ({
      owner = "blurgyy";
      repo = "tinytools";
      rev = "v1.1.2";
      fetchSubmodules = false;
      sha256 = "sha256-OjnSbiil2zx1sT93T6nPJXg+rwZYgryiT+DrpolrW7M=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./tinytools-v1.1.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  tmux-plugin-catppuccin = {
    pname = "tmux-plugin-catppuccin";
    version = "e2561decc2a4e77a0f8b7c05caf8d4f2af9714b3";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "tmux";
      rev = "e2561decc2a4e77a0f8b7c05caf8d4f2af9714b3";
      fetchSubmodules = false;
      sha256 = "sha256-6UmFGkUDoIe8k+FrzdzsKrDHHMNfkjAk0yyc+HV199M=";
    });
    date = "2022-12-14";
  };
  ttf-google-sans = {
    pname = "ttf-google-sans";
    version = "b1826355d8212378e5fd6094bbe504268fa6f85d";
    src = fetchFromGitHub ({
      owner = "sahibjotsaggu";
      repo = "Google-Sans-Fonts";
      rev = "b1826355d8212378e5fd6094bbe504268fa6f85d";
      fetchSubmodules = false;
      sha256 = "sha256-KJsLM0NkhxGtJ2GGTzIUjh3lWIdQFZQoD5c3AG2ApTg=";
    });
    date = "2018-08-01";
  };
  vim-plugin-fcitx5-ui-nvim = {
    pname = "vim-plugin-fcitx5-ui-nvim";
    version = "f11015ed8b75545a6f6b754bfca7ecfb1920ecdb";
    src = fetchFromGitHub ({
      owner = "black-desk";
      repo = "fcitx5-ui.nvim";
      rev = "f11015ed8b75545a6f6b754bfca7ecfb1920ecdb";
      fetchSubmodules = false;
      sha256 = "sha256-opi8DEILC08QrIBDNfMaGievzVrGbe79vdUI6dfK83o=";
    });
    date = "2023-01-18";
  };
  vscode-codicons = {
    pname = "vscode-codicons";
    version = "0.0.32";
    src = fetchFromGitHub ({
      owner = "microsoft";
      repo = "vscode-codicons";
      rev = "0.0.32";
      fetchSubmodules = false;
      sha256 = "sha256-5Hhqnwh9/s2rnITtcGnsR3M0DouTUh8CMLxgX5xrnyg=";
    });
  };
  wakapi = {
    pname = "wakapi";
    version = "2.6.1";
    src = fetchFromGitHub ({
      owner = "muety";
      repo = "wakapi";
      rev = "2.6.1";
      fetchSubmodules = false;
      sha256 = "sha256-C8tLPanL/v9YaLk07JPsgzE6S7ugsEiTsvxGoahJDa4=";
    });
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.23";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.23.tar.xz";
      sha256 = "sha256-JWk8aa/HVihwWLQi5sGGGPcnCMfh2YRkesfRGYoxaRQ=";
    };
  };
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.34.4";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.34.4";
      fetchSubmodules = false;
      sha256 = "sha256-ILjORslelnMTXfuVHS9UPa5qkXuYup/+wT/s1rTSpIY=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.34.4/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
