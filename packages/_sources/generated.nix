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
  alacritty-theme-catppuccin = {
    pname = "alacritty-theme-catppuccin";
    version = "3c808cbb4f9c87be43ba5241bc57373c793d2f17";
    src = fetchgit {
      url = "https://github.com/catppuccin/alacritty";
      rev = "3c808cbb4f9c87be43ba5241bc57373c793d2f17";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-w9XVtEe7TqzxxGUCDUR9BFkzLZjG8XrplXJ3lX6f+x0=";
    };
    date = "2022-09-27";
  };
  alist = {
    pname = "alist";
    version = "v3.15.0";
    src = fetchFromGitHub ({
      owner = "alist-org";
      repo = "alist";
      rev = "v3.15.0";
      fetchSubmodules = false;
      sha256 = "sha256-5Mq1n4PGMNmV2jLDWw30ZdQ9xXenaZvLb/PhVXcw5Pc=";
    });
  };
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "ios-15.4";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-15.4/AppleColorEmoji.ttf";
      sha256 = "sha256-CDmtLCzlytCZyMBDoMrdvs3ScHkMipuiXoNfc6bfimw=";
    };
  };
  bat-theme-catppuccin = {
    pname = "bat-theme-catppuccin";
    version = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    src = fetchgit {
      url = "https://github.com/catppuccin/bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    };
    date = "2022-11-10";
  };
  dms = {
    pname = "dms";
    version = "v1.5.0";
    src = fetchFromGitHub ({
      owner = "anacrolix";
      repo = "dms";
      rev = "v1.5.0";
      fetchSubmodules = false;
      sha256 = "sha256-cU9aN2qkJyuCKCxyHXVCNavRTZAlNKDmPQMm0HcaUCk=";
    });
  };
  dnsmasq-china-list = {
    pname = "dnsmasq-china-list";
    version = "7c03aedb102c0ab0a3861788eec1edcac25d989d";
    src = fetchFromGitHub ({
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "7c03aedb102c0ab0a3861788eec1edcac25d989d";
      fetchSubmodules = false;
      sha256 = "sha256-/r8Y4GUX/QBL+q4O6DZ7v9hthUjLyQ3oNAS3jNINhX8=";
    });
    date = "2023-03-28";
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
  foot-theme-catppuccin = {
    pname = "foot-theme-catppuccin";
    version = "79ab526a1428318dba793d58afd1d2545ed3cb7c";
    src = fetchgit {
      url = "https://github.com/catppuccin/foot";
      rev = "79ab526a1428318dba793d58afd1d2545ed3cb7c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-QojvIlaheEsHvv1vOIVEWg7eTo9zlcdkpb33BJLQB9M=";
    };
    date = "2022-12-26";
  };
  gdb-dashboard = {
    pname = "gdb-dashboard";
    version = "v0.16.1";
    src = fetchFromGitHub ({
      owner = "cyrus-and";
      repo = "gdb-dashboard";
      rev = "v0.16.1";
      fetchSubmodules = false;
      sha256 = "sha256-xRsmxiT+/TVW8k1unsCASU1j40jxVGVhSgOblLFT5bE=";
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
    version = "202303292210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202303292210/geoip.dat";
      sha256 = "sha256-SMxLYqZ2KX+VKqbMSDZcFsv60kQtqOuhUDqXPtTbWo4=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202303292210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202303292210/geosite.dat";
      sha256 = "sha256-LkYAPfrXEoIyZp2KImCWI/5Xcpku0DgRKAmtwIJjj4w=";
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
    version = "2023-03";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2023-03.csv.gz";
      sha256 = "sha256-/MnahdJkOg66KjQ4a8RhZvBXpQ7OVUvW8P2NnE2f8GY=";
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
    version = "1.1.7-1";
    src = fetchFromGitHub ({
      owner = "rustdesk";
      repo = "rustdesk-server";
      rev = "1.1.7-1";
      fetchSubmodules = false;
      sha256 = "sha256-Rv2dOZ0wSLkTr4DV8wjMpiWHLzzHB8WH+0l3STOZJ8U=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./rustdesk-server-1.1.7-1/Cargo.lock;
      outputHashes = {
        "confy-0.4.0" = "sha256-e91cvEixhpPzIthAxzTa3fDY6eCsHUy/eZQAqs7QTDo=";
        "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
        "tokio-socks-0.5.1" = "sha256-inmAJk0fAlsVNIwfD/M+htwIdQHwGSTRrEy6N/mspMI=";
      };
    };
  };
  simple-icons = {
    pname = "simple-icons";
    version = "8.8.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/8.8.0/simple-icons-font-8.8.0.zip";
      sha256 = "sha256-i4nW3mBD+zx2JeaCNCTpTdp8DSVENtdlOkhGWalpABw=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v2.3.3";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-nPDIAN6GvDHxEVsPR2LvjYCnSfbPpM90E7AfxWPMP2o=";
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
    version = "92b32c5c1a4e0df842980860071467e69dcb8b29";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "tmux";
      rev = "92b32c5c1a4e0df842980860071467e69dcb8b29";
      fetchSubmodules = false;
      sha256 = "sha256-tZfdh1CGH5hGAFT+lMPR9hthlEBTjSAklRiLx7NYTYg=";
    });
    date = "2023-03-28";
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
  v2ray-rules-dat = {
    pname = "v2ray-rules-dat";
    version = "4b06d8366ceb7b434bccb2b6bf84ba57fc72e51d";
    src = fetchFromGitHub ({
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "4b06d8366ceb7b434bccb2b6bf84ba57fc72e51d";
      fetchSubmodules = false;
      sha256 = "sha256-lpMD4xkKgj4Pg9WsjWV5c+WccpXYYuS4ptiFth4Z4Oc=";
    });
    date = "2023-03-29";
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
    version = "2.7.0";
    src = fetchFromGitHub ({
      owner = "muety";
      repo = "wakapi";
      rev = "2.7.0";
      fetchSubmodules = false;
      sha256 = "sha256-1EMSrHx6Tx58voz5veyNZg1gnubuGyg2K4dg2QdzmMw=";
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
    version = "v0.35.2";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.35.2";
      fetchSubmodules = false;
      sha256 = "sha256-2wgv84Qm/X5mcEcM5ch7tFHZVg/xassUOtssSzbr0fs=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.35.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
