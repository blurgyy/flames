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
  alcn-repo = {
    pname = "alcn-repo";
    version = "9dfc0d06dd44b6823789a756efe611f47fe69787";
    src = fetchFromGitHub {
      owner = "archlinuxcn";
      repo = "repo";
      rev = "9dfc0d06dd44b6823789a756efe611f47fe69787";
      fetchSubmodules = false;
      sha256 = "sha256-1o/vaDCdTKbqLn/VDungF+a1HsSRphq/q5OJ5UZQZVA=";
    };
    date = "2023-08-29";
  };
  alist = {
    pname = "alist";
    version = "v3.26.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.26.0";
      fetchSubmodules = false;
      sha256 = "sha256-bM7VA9nW1O1Gl9J2BEhnhcQ1Rg9AcJ7dYGNksYBsnhY=";
    };
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
  dcompass = {
    pname = "dcompass";
    version = "build-20230619_1015";
    src = fetchFromGitHub {
      owner = "compassd";
      repo = "dcompass";
      rev = "build-20230619_1015";
      fetchSubmodules = false;
      sha256 = "sha256-wFM3GV41P0fCAJ9lkhcZYolPfOYpbIVK5gZS3k3hA8s=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./dcompass-build-20230619_1015/Cargo.lock;
      outputHashes = {
        "cidr-utils-0.5.7" = "sha256-Kyvq1R5o7csR2BGWj9oZ6J+96fSqNBXBB2m/79HjGbM=";
      };
    };
  };
  dms = {
    pname = "dms";
    version = "v1.6.0";
    src = fetchFromGitHub {
      owner = "anacrolix";
      repo = "dms";
      rev = "v1.6.0";
      fetchSubmodules = false;
      sha256 = "sha256-QwRLNCXDu/dKh2o17AyASlVQPIEOX6e4kTINa2ZzZkU=";
    };
  };
  dnsmasq-china-list = {
    pname = "dnsmasq-china-list";
    version = "3b089556fefb171f49bb86b98530be039659236d";
    src = fetchFromGitHub {
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "3b089556fefb171f49bb86b98530be039659236d";
      fetchSubmodules = false;
      sha256 = "sha256-Fowizhg2AYmZ/lzGORR3KJxik7UeGjSTXar6eWpZfJc=";
    };
    date = "2023-08-28";
  };
  dt = {
    pname = "dt";
    version = "v0.7.10";
    src = fetchFromGitHub {
      owner = "blurgyy";
      repo = "dt";
      rev = "v0.7.10";
      fetchSubmodules = false;
      sha256 = "sha256-guTqOmrJLow84jUG6po6nfSFGFGEIdj6nf5Rm3GcLOg=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./dt-v0.7.10/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  fcitx5-fluent-dark-theme = {
    pname = "fcitx5-fluent-dark-theme";
    version = "77556203063760d87b87fb0b3b82f14cbe190193";
    src = fetchFromGitHub {
      owner = "Reverier-Xu";
      repo = "FluentDark-fcitx5";
      rev = "77556203063760d87b87fb0b3b82f14cbe190193";
      fetchSubmodules = false;
      sha256 = "sha256-om3jI6XNpkmFBXarwROKb6ldvCKaKzrBkLAdPmCxWkU=";
    };
    date = "2022-05-26";
  };
  fcitx5-sogou-themes = {
    pname = "fcitx5-sogou-themes";
    version = "fbc1e34179cb6a37f0ddb28024f9bf94f0cbd70d";
    src = fetchFromGitHub {
      owner = "sxqsfun";
      repo = "fcitx5-sogou-themes";
      rev = "fbc1e34179cb6a37f0ddb28024f9bf94f0cbd70d";
      fetchSubmodules = false;
      sha256 = "sha256-+Q8VNtAFWWD0UbF9nN+7FsCpcwUIi7HFJRbTeHU3HLo=";
    };
    date = "2021-08-26";
  };
  fish-plugin-catppuccin = {
    pname = "fish-plugin-catppuccin";
    version = "91e6d6721362be05a5c62e235ed8517d90c567c9";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "fish";
      rev = "91e6d6721362be05a5c62e235ed8517d90c567c9";
      fetchSubmodules = false;
      sha256 = "sha256-l9V7YMfJWhKDL65dNbxaddhaM6GJ0CFZ6z+4R6MJwBA=";
    };
    date = "2023-04-27";
  };
  fish-plugin-tide = {
    pname = "fish-plugin-tide";
    version = "v5.6.0";
    src = fetchFromGitHub {
      owner = "IlanCosman";
      repo = "tide";
      rev = "v5.6.0";
      fetchSubmodules = false;
      sha256 = "sha256-cCI1FDpvajt1vVPUd/WvsjX/6BJm6X1yFPjqohmo1rI=";
    };
  };
  fonts-collection = {
    pname = "fonts-collection";
    version = "f12fd1af32fdcce6e7703f457029a9c6b92970c8";
    src = fetchFromGitHub {
      owner = "dolbydu";
      repo = "font";
      rev = "f12fd1af32fdcce6e7703f457029a9c6b92970c8";
      fetchSubmodules = false;
      sha256 = "sha256-oeGC4rBtI1GKdC5gKiuRjKLU9RHksyKE+a8hRV0SVXw=";
    };
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
    src = fetchFromGitHub {
      owner = "cyrus-and";
      repo = "gdb-dashboard";
      rev = "v0.17.2";
      fetchSubmodules = false;
      sha256 = "sha256-UGHiYroUdqCr+a3ZgR1qKXQ3fiy2aQ5qo8gXefF9XDg=";
    };
  };
  gsfonts = {
    pname = "gsfonts";
    version = "20200910";
    src = fetchFromGitHub {
      owner = "ArtifexSoftware";
      repo = "urw-base35-fonts";
      rev = "20200910";
      fetchSubmodules = false;
      sha256 = "sha256-YQl5IDtodcbTV3D6vtJi7CwxVtHHl58fG6qCAoSaP4U=";
    };
  };
  halbot = {
    pname = "halbot";
    version = "cefc3341941915b57f550d7178512b827ed2f05a";
    src = fetchFromGitHub {
      owner = "Leask";
      repo = "halbot";
      rev = "cefc3341941915b57f550d7178512b827ed2f05a";
      fetchSubmodules = false;
      sha256 = "sha256-bIkhhFeJBMES86+HXBia/8900xVgfEB839Na6t0ZrUk=";
    };
    date = "2023-08-01";
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
  imgviz = {
    pname = "imgviz";
    version = "1.7.4";
    src = fetchurl {
      url = "https://pypi.org/packages/source/i/imgviz/imgviz-1.7.4.tar.gz";
      sha256 = "sha256-cCGrFAWYZQrwCl2FbzCE0F2M/bHAxXJZvjUIT5slpsc=";
    };
  };
  import-ply-as-verts-for-blender = {
    pname = "import-ply-as-verts-for-blender";
    version = "v2.1";
    src = fetchFromGitHub {
      owner = "TombstoneTumbleweedArt";
      repo = "import-ply-as-verts";
      rev = "v2.1";
      fetchSubmodules = false;
      sha256 = "sha256-uH0PADYv2hbDxPSuS5ckuov9mJ8pYuWt8hp18rXll6Y=";
    };
  };
  labelme = {
    pname = "labelme";
    version = "5.3.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/l/labelme/labelme-5.3.1.tar.gz";
      sha256 = "sha256-0DXgLwDiUeQ+GNu9NimC648dRZg2B7Io/ebK8cXk8l8=";
    };
  };
  libime-history-merge = {
    pname = "libime-history-merge";
    version = "v0.3.0";
    src = fetchFromGitHub {
      owner = "blurgyy";
      repo = "libime-history-merge";
      rev = "v0.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-aq8wRW+YFNNM1y6QzZzJDpisMJieURXjbKVoiRgtryE=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./libime-history-merge-v0.3.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  loyalsoldier-geoip = {
    pname = "loyalsoldier-geoip";
    version = "202308282208";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202308282208/geoip.dat";
      sha256 = "sha256-wLEWLWThs4v6Y0RXmKh28WzEFeP9/g8JLpl4Ls0DiPk=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202308282208";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202308282208/geosite.dat";
      sha256 = "sha256-+rX5naIG8RjKDaXpCiqvKVbSq9SRsXB2+5PALEev2RE=";
    };
  };
  luarock-dbus_proxy = {
    pname = "luarock-dbus_proxy";
    version = "v0.10.3";
    src = fetchFromGitHub {
      owner = "stefano-m";
      repo = "lua-dbus_proxy";
      rev = "v0.10.3";
      fetchSubmodules = false;
      sha256 = "sha256-Yd8TN/vKiqX7NOZyy8OwOnreWS5gdyVMTAjFqoAuces=";
    };
  };
  nbfc-linux = {
    pname = "nbfc-linux";
    version = "0.1.7";
    src = fetchFromGitHub {
      owner = "nbfc-linux";
      repo = "nbfc-linux";
      rev = "0.1.7";
      fetchSubmodules = false;
      sha256 = "sha256-Q/W/O2cevofDNzn2ly1r6mfl39VnSrYxocKLr+JxQ3s=";
    };
  };
  nftables-geoip-db = {
    pname = "nftables-geoip-db";
    version = "2023-08";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2023-08.csv.gz";
      sha256 = "sha256-g0YYNb/sZvuU8E/7XuDbj5Js+wA4c4Bxnj7UP7gxxow=";
    };
  };
  primitive = {
    pname = "primitive";
    version = "0373c216458be1c4b40655b796a3aefedf8b7d23";
    src = fetchFromGitHub {
      owner = "fogleman";
      repo = "primitive";
      rev = "0373c216458be1c4b40655b796a3aefedf8b7d23";
      fetchSubmodules = false;
      sha256 = "sha256-stKb3tPP/pgHTfdyTmWwVj/hLjOHtFpvJxXgBhhWgPQ=";
    };
    date = "2020-05-03";
  };
  rssbot = {
    pname = "rssbot";
    version = "v2.0.0-alpha.11";
    src = fetchFromGitHub {
      owner = "iovxw";
      repo = "rssbot";
      rev = "v2.0.0-alpha.11";
      fetchSubmodules = false;
      sha256 = "sha256-gNCjphzJWGjdRsyytjp1l1eYqPYI3S+kpZJ/BpJl7ac=";
    };
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
    src = fetchFromGitHub {
      owner = "rustdesk";
      repo = "rustdesk-server";
      rev = "1.1.7-1";
      fetchSubmodules = false;
      sha256 = "sha256-Rv2dOZ0wSLkTr4DV8wjMpiWHLzzHB8WH+0l3STOZJ8U=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./rustdesk-server-1.1.7-1/Cargo.lock;
      outputHashes = {
        "confy-0.4.0" = "sha256-e91cvEixhpPzIthAxzTa3fDY6eCsHUy/eZQAqs7QTDo=";
        "tokio-socks-0.5.1" = "sha256-inmAJk0fAlsVNIwfD/M+htwIdQHwGSTRrEy6N/mspMI=";
        "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
      };
    };
  };
  sc-fonts = {
    pname = "sc-fonts";
    version = "287399335ec1beb72062ce67c36eaa8bec35f386";
    src = fetchFromGitHub {
      owner = "Haixing-Hu";
      repo = "latex-chinese-fonts";
      rev = "287399335ec1beb72062ce67c36eaa8bec35f386";
      fetchSubmodules = false;
      sha256 = "sha256-v3pKnmEUeLwLY7Oqkvhet+wSw53qJbQOhesuYrg1qXw=";
    };
    date = "2018-08-08";
  };
  simple-icons = {
    pname = "simple-icons";
    version = "9.12.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/9.12.0/simple-icons-font-9.12.0.zip";
      sha256 = "sha256-Y0YohFFMgcyOucxbd9mYBkYb2XGURsbuX73mDftVT4A=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v3.0.2";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-VVs1Wu/g5phFaXdp+w95dvHZ5u/9BjIfpf4IXWsZ/+s=";
    };
  };
  tdesktop-megumifox = {
    pname = "tdesktop-megumifox";
    version = "v4.8.4";
    src = fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v4.8.4";
      fetchSubmodules = true;
      sha256 = "sha256-DRVFngQ4geJx2/7pT1VJzkcBZnVGgDvcGGUr9r38gSU=";
    };
  };
  telegram-send = {
    pname = "telegram-send";
    version = "0.34";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/telegram-send/telegram-send-0.34.tar.gz";
      sha256 = "sha256-KR9mU8FvA+vOz4FCIljrFk9XCNthC8d55of5Pta/oyQ=";
    };
  };
  tinytools = {
    pname = "tinytools";
    version = "v1.1.2";
    src = fetchFromGitHub {
      owner = "blurgyy";
      repo = "tinytools";
      rev = "v1.1.2";
      fetchSubmodules = false;
      sha256 = "sha256-OjnSbiil2zx1sT93T6nPJXg+rwZYgryiT+DrpolrW7M=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./tinytools-v1.1.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  tmux-plugin-catppuccin = {
    pname = "tmux-plugin-catppuccin";
    version = "e7b50832f9bc59b0b5ef5316ba2cd6f61e4e22fc";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "e7b50832f9bc59b0b5ef5316ba2cd6f61e4e22fc";
      fetchSubmodules = false;
      sha256 = "sha256-9ZfUqEKEexSh06QyR5C+tYd4tNfBi3PsA+STzUv4+/s=";
    };
  };
  tro = {
    pname = "tro";
    version = "2.9.1";
    src = fetchFromGitHub {
      owner = "MichaelAquilina";
      repo = "tro";
      rev = "2.9.1";
      fetchSubmodules = false;
      sha256 = "sha256-u/b6MJOBX1yxUZ5a2qZdrt10v1sxCtLwBBKSn0oPakM=";
    };
  };
  v2ray-rules-dat = {
    pname = "v2ray-rules-dat";
    version = "0b2372650a178efd86ae1c62fc84900509f7525f";
    src = fetchFromGitHub {
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "0b2372650a178efd86ae1c62fc84900509f7525f";
      fetchSubmodules = false;
      sha256 = "sha256-vnyiJJnro5Md1/sGj2HgcZKVlnGXo4Mr2t4HKU+T7VY=";
    };
    date = "2023-08-28";
  };
  video-compare = {
    pname = "video-compare";
    version = "20230807";
    src = fetchFromGitHub {
      owner = "pixop";
      repo = "video-compare";
      rev = "20230807";
      fetchSubmodules = false;
      sha256 = "sha256-b489PDAAY3mgGU4V9DOpn/LJeRmGxrobb9pgZZFgdXQ=";
    };
  };
  vim-plugin-bigfile-nvim = {
    pname = "vim-plugin-bigfile-nvim";
    version = "9616b73670ffeb92679677554ded88854ae42cf8";
    src = fetchFromGitHub {
      owner = "LunarVim";
      repo = "bigfile.nvim";
      rev = "9616b73670ffeb92679677554ded88854ae42cf8";
      fetchSubmodules = false;
      sha256 = "sha256-jHWWPlWyOxKWBTrCS04vTm5ywUsX/IxBHmphoK2jLic=";
    };
    date = "2023-06-28";
  };
  vim-plugin-fcitx5-ui-nvim = {
    pname = "vim-plugin-fcitx5-ui-nvim";
    version = "665ecb1365639cd6c14e47f4bacd9121106025a2";
    src = fetchFromGitHub {
      owner = "black-desk";
      repo = "fcitx5-ui.nvim";
      rev = "665ecb1365639cd6c14e47f4bacd9121106025a2";
      fetchSubmodules = false;
      sha256 = "sha256-FnxhCoBC8DDUlbHIi6xkIq53Nc6DVHwXD9j9LOdRzhc=";
    };
    date = "2023-06-16";
  };
  vim-plugin-rainbow-delimiters-nvim = {
    pname = "vim-plugin-rainbow-delimiters-nvim";
    version = "9cbd3dc409af1f5531778ccd1ea6bce668241f39";
    src = fetchgit {
      url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      rev = "9cbd3dc409af1f5531778ccd1ea6bce668241f39";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-4aH2UhG1alE9F1jOMZUSSnvHmWYR6QSC4HwH3oOv5GM=";
    };
    date = "2023-08-26";
  };
  vscode-codicons = {
    pname = "vscode-codicons";
    version = "0.0.33";
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-codicons";
      rev = "0.0.33";
      fetchSubmodules = false;
      sha256 = "sha256-E9Y6o0tjZhNhiRCqQUP+QrGv73Et/qDA0r9oOaALCoU=";
    };
  };
  wakapi = {
    pname = "wakapi";
    version = "2.8.1";
    src = fetchFromGitHub {
      owner = "muety";
      repo = "wakapi";
      rev = "2.8.1";
      fetchSubmodules = false;
      sha256 = "sha256-5EUXhKv4cLDaHr6Q2mel3YbVPAYRJd1JtHyWn7kQy8Y=";
    };
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.24";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.24.tar.xz";
      sha256 = "sha256-PoI/cXIFGc7THEx9K/r3Eg2cAcWaCEPfy+k8lcZNgcE=";
    };
  };
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.38.0";
    src = fetchFromGitHub {
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.38.0";
      fetchSubmodules = false;
      sha256 = "sha256-+i4lY2VB/g6/dwN4dDwsiI+3R299ssBY90fpnvkVrXU=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.38.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
