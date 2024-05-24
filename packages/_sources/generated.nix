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
  alcn-repo = {
    pname = "alcn-repo";
    version = "705a3c7683cd9eea70b6dbbdfa53a5da0ab75dc4";
    src = fetchFromGitHub {
      owner = "archlinuxcn";
      repo = "repo";
      rev = "705a3c7683cd9eea70b6dbbdfa53a5da0ab75dc4";
      fetchSubmodules = false;
      sha256 = "sha256-iRYeDG/XvD//4fKQiHcuUV2cGuaLhj908BHUg8AQcvA=";
    };
    date = "2024-05-25";
  };
  alist = {
    pname = "alist";
    version = "v3.35.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.35.0";
      fetchSubmodules = false;
      sha256 = "sha256-N9WgaPzc8cuDN7N0Ny3t6ARGla0lCluzF2Mut3Pg880=";
    };
  };
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "v17.4";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v17.4/AppleColorEmoji.ttf";
      sha256 = "sha256-SG3JQLybhY/fMX+XqmB/BKhQSBB0N1VRqa+H6laVUPE=";
    };
  };
  bat-theme-catppuccin = {
    pname = "bat-theme-catppuccin";
    version = "d714cc1d358ea51bfc02550dabab693f70cccea0";
    src = fetchgit {
      url = "https://github.com/catppuccin/bat";
      rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
    };
    date = "2024-04-25";
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
    version = "e54aa75ca9c6567ac5b67093e5471eb1c8041e86";
    src = fetchFromGitHub {
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "e54aa75ca9c6567ac5b67093e5471eb1c8041e86";
      fetchSubmodules = false;
      sha256 = "sha256-9hiya347cBq/WyDvVsGq69cOiQnNkR1KAd/qi25zb8k=";
    };
    date = "2024-05-24";
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
    version = "dc98bc13e8eadabed7530a68706f0a2a0a07340e";
    src = fetchFromGitHub {
      owner = "Reverier-Xu";
      repo = "FluentDark-fcitx5";
      rev = "dc98bc13e8eadabed7530a68706f0a2a0a07340e";
      fetchSubmodules = false;
      sha256 = "sha256-d1Y0MUOofBxwyeoXxUzQHrngL1qnL3TMa5DhDki7Pk8=";
    };
    date = "2024-03-30";
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
  fedora-virtio-win-iso = {
    pname = "fedora-virtio-win-iso";
    version = "0.1.240-1";
    src = fetchurl {
      url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso";
      sha256 = "sha256-69SCWGaPf3jgJu0nbCip0Z2D4CD/oICtaZENyGu8vMY=";
    };
  };
  fish-plugin-catppuccin = {
    pname = "fish-plugin-catppuccin";
    version = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "fish";
      rev = "a3b9eb5eaf2171ba1359fe98f20d226c016568cf";
      fetchSubmodules = false;
      sha256 = "sha256-shQxlyoauXJACoZWtRUbRMxmm10R8vOigXwjxBhG8ng=";
    };
    date = "2024-05-14";
  };
  fish-plugin-tide = {
    pname = "fish-plugin-tide";
    version = "v6.1.1";
    src = fetchFromGitHub {
      owner = "IlanCosman";
      repo = "tide";
      rev = "v6.1.1";
      fetchSubmodules = false;
      sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
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
    version = "307611230661b7b1787feb7f9d122e851bae97e9";
    src = fetchgit {
      url = "https://github.com/catppuccin/foot";
      rev = "307611230661b7b1787feb7f9d122e851bae97e9";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-mkPYHDJtfdfDnqLr1YOjaBpn4lCceok36LrnkUkNIE4=";
    };
    date = "2024-05-02";
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
    version = "1.7.5";
    src = fetchurl {
      url = "https://pypi.org/packages/source/i/imgviz/imgviz-1.7.5.tar.gz";
      sha256 = "sha256-2tiIaKpFDesQXgjDidPMf/1PYsx7wwiF4zzji6KRmok=";
    };
  };
  import-ply-as-verts-for-blender = {
    pname = "import-ply-as-verts-for-blender";
    version = "v3.0";
    src = fetchFromGitHub {
      owner = "TombstoneTumbleweedArt";
      repo = "import-ply-as-verts";
      rev = "v3.0";
      fetchSubmodules = false;
      sha256 = "sha256-GzRrcJwqC78jNKkGIz5JjXtMXsPLb2jclYsubf5VB6g=";
    };
  };
  labelme = {
    pname = "labelme";
    version = "5.4.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/l/labelme/labelme-5.4.1.tar.gz";
      sha256 = "sha256-qjSnHV8fVWHEzAtD4eZhknYpE87RLxNI4swqEvraRC4=";
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
    version = "202405232210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202405232210/geoip.dat";
      sha256 = "sha256-22P2THf5U9ABtc5742tjJfzzwbtKWElkcJ1NThg7r3c=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202405232210";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202405232210/geosite.dat";
      sha256 = "sha256-OVuq9XOxZgzMGOGP3gL0u1Qjq07KpZilvIKVrZio++M=";
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
  mayo = {
    pname = "mayo";
    version = "ec5d7d7590396866f2db26c85826e6c4c2b272c4";
    src = fetchFromGitHub {
      owner = "fougue";
      repo = "mayo";
      rev = "ec5d7d7590396866f2db26c85826e6c4c2b272c4";
      fetchSubmodules = false;
      sha256 = "sha256-1jruBF02GysARyfu4RqavZ4kajRMqJJtbeEz1g6ihOE=";
    };
    date = "2024-05-20";
  };
  nftables-geoip-db = {
    pname = "nftables-geoip-db";
    version = "2024-05";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2024-05.csv.gz";
      sha256 = "sha256-XHqVZA4jz5zwH7oOwuDSMAGZRpFa2DzneZlj1l4X15Q=";
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
  pypipe = {
    pname = "pypipe";
    version = "29f65954c67703346c20fb8de7889b6c1b4d77b2";
    src = fetchgit {
      url = "https://github.com/bugen/pypipe";
      rev = "29f65954c67703346c20fb8de7889b6c1b4d77b2";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-DIYZormAS2xFvw5ydYS5rtN7InkW1jvwuMYcKMAhJi8=";
    };
    date = "2024-01-04";
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
    version = "11.12.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/11.12.0/simple-icons-font-11.12.0.zip";
      sha256 = "sha256-4Ar7+ykhxbVBxNHg112sUx4uXIVUFF/2e0uoEyWkOv4=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v3.2.1";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-vFnC6nTQIqYmL/njcv3lw2zVrj+CpWeUFIns+rTwPWY=";
    };
  };
  tdesktop-megumifox = {
    pname = "tdesktop-megumifox";
    version = "v4.16.8";
    src = fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v4.16.8";
      fetchSubmodules = true;
      sha256 = "sha256-M8wFhuTTEJippgvS93LNRqREV2TGF04ccps5oOmSr+0=";
    };
  };
  telegram-send = {
    pname = "telegram-send";
    version = "0.37";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/telegram-send/telegram-send-0.37.tar.gz";
      sha256 = "sha256-n2mrszFZjktrqKFzsV33397E7sF+NgCkPVVMU7AVBpU=";
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
    version = "7ee3b43ceac33dcb0139f15addc43373b61c6020";
    src = fetchFromGitHub {
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "7ee3b43ceac33dcb0139f15addc43373b61c6020";
      fetchSubmodules = false;
      sha256 = "sha256-l1zBzj5oMviiz4BHIvJStYps3DVpBb80hpy/Tj220Jw=";
    };
    date = "2024-05-23";
  };
  video-compare = {
    pname = "video-compare";
    version = "20240429";
    src = fetchFromGitHub {
      owner = "pixop";
      repo = "video-compare";
      rev = "20240429";
      fetchSubmodules = false;
      sha256 = "sha256-jphY4ap5lfGyaB4NwixLH8EoaaXStRsugatuD8RPggY=";
    };
  };
  vim-plugin-bigfile-nvim = {
    pname = "vim-plugin-bigfile-nvim";
    version = "33eb067e3d7029ac77e081cfe7c45361887a311a";
    src = fetchFromGitHub {
      owner = "LunarVim";
      repo = "bigfile.nvim";
      rev = "33eb067e3d7029ac77e081cfe7c45361887a311a";
      fetchSubmodules = false;
      sha256 = "sha256-fabA2mVZAZg5Qot4ED9cJ1YMZ4wX4OvURNhIvKltFtA=";
    };
    date = "2023-11-06";
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
    version = "849803e0a687c6ef7c9a0d305bd4d441017b8abf";
    src = fetchgit {
      url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      rev = "849803e0a687c6ef7c9a0d305bd4d441017b8abf";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-+6u3fo1ennJ/BS/jWdHnBtLBR65abFPU6sVvjkPtpqY=";
    };
    date = "2024-05-24";
  };
  vim-plugin-typescript-tools-nvim = {
    pname = "vim-plugin-typescript-tools-nvim";
    version = "c43d9580c3ff5999a1eabca849f807ab33787ea7";
    src = fetchgit {
      url = "https://github.com/pmizio/typescript-tools.nvim";
      rev = "c43d9580c3ff5999a1eabca849f807ab33787ea7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-kpdDYVd6uSuJImS9LU5p/vJgtj9tToNBvRTJHpsHyak=";
    };
    date = "2024-01-16";
  };
  vscode-codicons = {
    pname = "vscode-codicons";
    version = "0.0.36";
    src = fetchurl {
      url = "https://github.com/microsoft/vscode-codicons/releases/download/0.0.36/codicon.ttf";
      sha256 = "sha256-NgUnV1OVrXD5QO/x5D63wuxk9OafidxYYbc0INKlePA=";
    };
  };
  wakapi = {
    pname = "wakapi";
    version = "2.11.2";
    src = fetchFromGitHub {
      owner = "muety";
      repo = "wakapi";
      rev = "2.11.2";
      fetchSubmodules = false;
      sha256 = "sha256-lBjYtb64blFUH/iW/SmC4A7nX9asokvsNKu6QVYgmZ8=";
    };
  };
  waypoint = {
    pname = "waypoint";
    version = "702657a6c18688fed97e498a9c95771b073835cc";
    src = fetchFromGitHub {
      owner = "tadeokondrak";
      repo = "waypoint";
      rev = "702657a6c18688fed97e498a9c95771b073835cc";
      fetchSubmodules = false;
      sha256 = "sha256-ZRddQzSz++MlbbFBt5b1uZeOsOijdBtd9RfQeeTbQA4=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./waypoint-702657a6c18688fed97e498a9c95771b073835cc/Cargo.lock;
      outputHashes = {
        
      };
    };
    date = "2024-04-17";
  };
  wl-screenrec = {
    pname = "wl-screenrec";
    version = "v0.1.3";
    src = fetchFromGitHub {
      owner = "russelltg";
      repo = "wl-screenrec";
      rev = "v0.1.3";
      fetchSubmodules = false;
      sha256 = "sha256-ThPZPV1GyMFRu94O9WwUpXbR4gnIML26K7TyIfXZlcI=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wl-screenrec-v0.1.3/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.26";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.26.tar.xz";
      sha256 = "sha256-C1LfIRe6zy4y0dP5jQnb+IsnQ5BzPTlVaZsQisr58qY=";
    };
  };
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.40.1";
    src = fetchFromGitHub {
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.40.1";
      fetchSubmodules = false;
      sha256 = "sha256-n8cwsCeKWzTw/psvLL3chBr8EcwGoeKB8JeiLSLna1k=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.40.1/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
