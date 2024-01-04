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
    version = "5e929777b6b955d7e48efb8f42a8964a00666dde";
    src = fetchFromGitHub {
      owner = "archlinuxcn";
      repo = "repo";
      rev = "5e929777b6b955d7e48efb8f42a8964a00666dde";
      fetchSubmodules = false;
      sha256 = "sha256-rvH/n213r2Ugyyte8Pqf8OTqH2brPEXjp4X++8ZfjIw=";
    };
    date = "2024-01-04";
  };
  alist = {
    pname = "alist";
    version = "v3.29.1";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.29.1";
      fetchSubmodules = false;
      sha256 = "sha256-YS/rA7gGf4kDIjnnaDG6CTDAk+odrorJ62rN/ZQRyIs=";
    };
  };
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "v16.4-patch.1";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v16.4-patch.1/AppleColorEmoji.ttf";
      sha256 = "sha256-1e1Xz7wF1NhCe0zUdJWXE6hPGmkylAeggsN01T3WWpU=";
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
  clidle = {
    pname = "clidle";
    version = "fe27556c1147333af2cfe81cbc40f4f60ea191ee";
    src = fetchFromGitHub {
      owner = "ajeetdsouza";
      repo = "clidle";
      rev = "fe27556c1147333af2cfe81cbc40f4f60ea191ee";
      fetchSubmodules = false;
      sha256 = "sha256-zSrCYNgN4wKFgRdog/7ANumy0GsqOMTHqLTT8p7LEgE=";
    };
    date = "2022-05-25";
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
    version = "afbac95acd30b0e4f6eb23fab3c2c7db0c85f4f2";
    src = fetchFromGitHub {
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "afbac95acd30b0e4f6eb23fab3c2c7db0c85f4f2";
      fetchSubmodules = false;
      sha256 = "sha256-GkeDrtgxW8p2LANPWCCWqgp7T67NDEMYmZPQ1qwsoLE=";
    };
    date = "2023-12-30";
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
    version = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "fish";
      rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
      fetchSubmodules = false;
      sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
    };
    date = "2023-11-02";
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
    version = "fc737884229b4798c76530c3123baba23e796716";
    src = fetchFromGitHub {
      owner = "Leask";
      repo = "halbot";
      rev = "fc737884229b4798c76530c3123baba23e796716";
      fetchSubmodules = false;
      sha256 = "sha256-wuL3qB50DXq+nhgSnMnOTCwwyXsZlL8eYuUrp0dleoU=";
    };
    date = "2024-01-04";
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
    version = "5.4.0.post1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/l/labelme/labelme-5.4.0.post1.tar.gz";
      sha256 = "sha256-I5mgsWAisESmd4rOcoUZA8G87LgYOKhHm2FuGaNp+Bo=";
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
    version = "202401032209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202401032209/geoip.dat";
      sha256 = "sha256-dyhMpE/fznIMGfe91wi91y69W/orKgcMFyhaddpmCVs=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202401032209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202401032209/geosite.dat";
      sha256 = "sha256-1kFZfW0ORCTbuqpvP/oRG9Q3TDuRxn6dqAosWE9outc=";
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
    version = "2024-01";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2024-01.csv.gz";
      sha256 = "sha256-5c5cVproKAsJ/bH8IrMeXLtWhYLvpjotZZRBwToMN2U=";
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
    version = "10.4.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/10.4.0/simple-icons-font-10.4.0.zip";
      sha256 = "sha256-nLyKcLarioMft0e7yk+EXoN+swekFvG4gCVua1dizZQ=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v3.1.1";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-jGRhPv4MXRFmSpMdJB51bqQiz0rRjXmfHLXkMXEianY=";
    };
  };
  tdesktop-megumifox = {
    pname = "tdesktop-megumifox";
    version = "v4.14.2";
    src = fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v4.14.2";
      fetchSubmodules = true;
      sha256 = "sha256-1awdqojy2nWUtrK/VS8ALCK47rGWpS8Q6H2LciG2ymw=";
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
    version = "61916482a7484c5676ddca2bcb580c85ef37b26f";
    src = fetchFromGitHub {
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "61916482a7484c5676ddca2bcb580c85ef37b26f";
      fetchSubmodules = false;
      sha256 = "sha256-CtnlOBXsUybfKkIAqUiR4Tv0+S0KjYp3KVeGONv+owk=";
    };
    date = "2024-01-03";
  };
  video-compare = {
    pname = "video-compare";
    version = "20231224";
    src = fetchFromGitHub {
      owner = "pixop";
      repo = "video-compare";
      rev = "20231224";
      fetchSubmodules = false;
      sha256 = "sha256-m1DeWx3gUsfPS5mwRxSoG0Xn/mXJh8h3KpMC0hhe0oc=";
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
    version = "4a90ac83c7c8e0ba8a1b6af38bed6d5ee1b04e08";
    src = fetchgit {
      url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      rev = "4a90ac83c7c8e0ba8a1b6af38bed6d5ee1b04e08";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-sUB85XGP3XQvF3TcdLhKLCDoSTFOeOlUiptK9DjYYqE=";
    };
    date = "2024-01-02";
  };
  vim-plugin-typescript-tools-nvim = {
    pname = "vim-plugin-typescript-tools-nvim";
    version = "829b5dc4f6704b249624e5157ad094dcb20cdc6b";
    src = fetchgit {
      url = "https://github.com/pmizio/typescript-tools.nvim";
      rev = "829b5dc4f6704b249624e5157ad094dcb20cdc6b";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-O/wJzIflMXUc8FbeiUcYuWgE4md8gjK7KUifWFYZNXg=";
    };
    date = "2023-12-19";
  };
  vscode-codicons = {
    pname = "vscode-codicons";
    version = "0.0.35";
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-codicons";
      rev = "0.0.35";
      fetchSubmodules = false;
      sha256 = "sha256-d0UuB/fNXTonaLWdCa1ZlZxnwZuI8+spBk8bFwYSuK4=";
    };
  };
  wakapi = {
    pname = "wakapi";
    version = "2.10.2";
    src = fetchFromGitHub {
      owner = "muety";
      repo = "wakapi";
      rev = "2.10.2";
      fetchSubmodules = false;
      sha256 = "sha256-ecbWP6WnFCMCnk8o3A0UUdMj8cSmKm5KD/gVN/AVvIY=";
    };
  };
  wl-screenrec = {
    pname = "wl-screenrec";
    version = "v0.1.2";
    src = fetchFromGitHub {
      owner = "russelltg";
      repo = "wl-screenrec";
      rev = "v0.1.2";
      fetchSubmodules = false;
      sha256 = "sha256-Ol4/e/EETA8MXqiyCzcV6s4DjFf6ldUortOrzJ80/Ko=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./wl-screenrec-v0.1.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.25";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.25.tar.xz";
      sha256 = "sha256-jJ9Mao6S63z78D9OvLHh55MlbC79AibYMxK/sP/hS4Q=";
    };
  };
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.39.2";
    src = fetchFromGitHub {
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.39.2";
      fetchSubmodules = false;
      sha256 = "sha256-FSLbRfxSWY0a9H9iHT3oQ2SXwB70AwyH0Cm8sDZGaUk=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.39.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
