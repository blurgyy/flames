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
    version = "v3.16.0";
    src = fetchFromGitHub ({
      owner = "alist-org";
      repo = "alist";
      rev = "v3.16.0";
      fetchSubmodules = false;
      sha256 = "sha256-YM/LX6nW6n4nhcF4ALoeXquvvHudk95a+4GYzI3Qdm0=";
    });
  };
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "v16.4";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v16.4/AppleColorEmoji.ttf";
      sha256 = "sha256-goY9lWBtOnOUotitjVfe96zdmjYTPT6PVOnZ0MEWh0U=";
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
    version = "258471575d7f44a99ca366dc108799d72332ac98";
    src = fetchFromGitHub ({
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "258471575d7f44a99ca366dc108799d72332ac98";
      fetchSubmodules = false;
      sha256 = "sha256-W0+xwHZ7hmS+sZgTL2b135KVzT1kAaKOvITpP+sSTTY=";
    });
    date = "2023-04-23";
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
  fonts-collection = {
    pname = "fonts-collection";
    version = "f12fd1af32fdcce6e7703f457029a9c6b92970c8";
    src = fetchFromGitHub ({
      owner = "dolbydu";
      repo = "font";
      rev = "f12fd1af32fdcce6e7703f457029a9c6b92970c8";
      fetchSubmodules = false;
      sha256 = "sha256-oeGC4rBtI1GKdC5gKiuRjKLU9RHksyKE+a8hRV0SVXw=";
    });
    date = "2013-11-16";
  };
  foot-theme-catppuccin = {
    pname = "foot-theme-catppuccin";
    version = "009cd57bd3491c65bb718a269951719f94224eb7";
    src = fetchgit {
      url = "https://github.com/catppuccin/foot";
      rev = "009cd57bd3491c65bb718a269951719f94224eb7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-gO+ZfG2Btehp8uG+h4JE7MSFsic+Qvfzio8Um0lDGTg=";
    };
    date = "2023-04-09";
  };
  gdb-dashboard = {
    pname = "gdb-dashboard";
    version = "v0.17.2";
    src = fetchFromGitHub ({
      owner = "cyrus-and";
      repo = "gdb-dashboard";
      rev = "v0.17.2";
      fetchSubmodules = false;
      sha256 = "sha256-UGHiYroUdqCr+a3ZgR1qKXQ3fiy2aQ5qo8gXefF9XDg=";
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
  halbot = {
    pname = "halbot";
    version = "7520fbf3d088b14733b07e37f5fb1444f797cb98";
    src = fetchFromGitHub ({
      owner = "Leask";
      repo = "halbot";
      rev = "7520fbf3d088b14733b07e37f5fb1444f797cb98";
      fetchSubmodules = false;
      sha256 = "sha256-EPgE1s8XnickE1DpNQMmS2rqHvRxOHgBnxsBEs+BG1o=";
    });
    date = "2023-04-18";
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
  latex-fonts = {
    pname = "latex-fonts";
    version = "287399335ec1beb72062ce67c36eaa8bec35f386";
    src = fetchFromGitHub ({
      owner = "Haixing-Hu";
      repo = "latex-chinese-fonts";
      rev = "287399335ec1beb72062ce67c36eaa8bec35f386";
      fetchSubmodules = false;
      sha256 = "sha256-v3pKnmEUeLwLY7Oqkvhet+wSw53qJbQOhesuYrg1qXw=";
    });
    date = "2018-08-08";
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
    version = "202304242209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202304242209/geoip.dat";
      sha256 = "sha256-dCuAa7KCKKRj7iC2IunwTW/6sCl93SlVnXtjWElBb4E=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202304242209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202304242209/geosite.dat";
      sha256 = "sha256-U9+WiM2eMkyv+1Etpfc7HsSkb/+yOIE8HAU6QXkHEXU=";
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
    version = "2023-04";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2023-04.csv.gz";
      sha256 = "sha256-r6UWoK+AUbL7nnGhI6JPhkF7aY6TiqbzuDWo6ANN+8c=";
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
    version = "8.11.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/8.11.0/simple-icons-font-8.11.0.zip";
      sha256 = "sha256-WaexbmwM/ObZw8Hc5GTa9tLQxH5IgCh0kbOtyO9c0lU=";
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
    version = "4e48b09a76829edc7b55fbb15467cf0411f07931";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "tmux";
      rev = "4e48b09a76829edc7b55fbb15467cf0411f07931";
      fetchSubmodules = false;
      sha256 = "sha256-bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
    });
    date = "2023-04-03";
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
    version = "6f12be0dbbf7cdbf7fd77f072580d33651f706fe";
    src = fetchFromGitHub ({
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "6f12be0dbbf7cdbf7fd77f072580d33651f706fe";
      fetchSubmodules = false;
      sha256 = "sha256-W7J9hyRJYgp/adGIvX66P33GzqQeWhM6Lm2kzWh5Dvo=";
    });
    date = "2023-04-24";
  };
  vim-plugin-bigfile-nvim = {
    pname = "vim-plugin-bigfile-nvim";
    version = "c1bad34ce742b4f360b67ca23c873fef998240fc";
    src = fetchFromGitHub ({
      owner = "LunarVim";
      repo = "bigfile.nvim";
      rev = "c1bad34ce742b4f360b67ca23c873fef998240fc";
      fetchSubmodules = false;
      sha256 = "sha256-UgAjRutParv851i7colnevHLoBmvtbTX9vxHbyeQ8sk=";
    });
    date = "2022-12-01";
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
    version = "v0.36.0";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.36.0";
      fetchSubmodules = false;
      sha256 = "sha256-6hd4vZfcztD+i3hRP057Z9kYbl/QYK7e5X18tKRmNVQ=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.36.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
