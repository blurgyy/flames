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
    version = "24759dd998deee6d07ec161b47855ad1790f24f2";
    src = fetchFromGitHub {
      owner = "archlinuxcn";
      repo = "repo";
      rev = "24759dd998deee6d07ec161b47855ad1790f24f2";
      fetchSubmodules = false;
      sha256 = "sha256-1ydHMGAmfaVXmK1rCiSzlFifTS4PEdl5GDy+GN+6+GA=";
    };
    date = "2023-11-02";
  };
  alist = {
    pname = "alist";
    version = "v3.28.0";
    src = fetchFromGitHub {
      owner = "alist-org";
      repo = "alist";
      rev = "v3.28.0";
      fetchSubmodules = false;
      sha256 = "sha256-btyKSlLGKtCGyjpJuaAQFffGiUntrKTjfT7bK7REvMg=";
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
    version = "db49c15abc364a7a041aa95a8f763cf1a957b0de";
    src = fetchFromGitHub {
      owner = "felixonmars";
      repo = "dnsmasq-china-list";
      rev = "db49c15abc364a7a041aa95a8f763cf1a957b0de";
      fetchSubmodules = false;
      sha256 = "sha256-U0VGlPvLB2oULSkfZOBEKCKze+zmjmpZIIVI1wZ+ofA=";
    };
    date = "2023-10-25";
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
    version = "v6.0.1";
    src = fetchFromGitHub {
      owner = "IlanCosman";
      repo = "tide";
      rev = "v6.0.1";
      fetchSubmodules = false;
      sha256 = "sha256-oLD7gYFCIeIzBeAW1j62z5FnzWAp3xSfxxe7kBtTLgA=";
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
    version = "202311012208";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202311012208/geoip.dat";
      sha256 = "sha256-8xDQodReOKIUqNaaTUIhZbBOztz6p7zGLNG86VUSCF4=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202311012208";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202311012208/geosite.dat";
      sha256 = "sha256-y1TVr/O8obww91Jt9wAJ3NSljUDlqdVEQf7bi0Yx2Eo=";
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
    version = "2023-11";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2023-11.csv.gz";
      sha256 = "sha256-rlmoq40QXXg9o0XR8iUq3p5HCC20knZalND2FZ5ps4g=";
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
    version = "3da3c1020117b1dad6fa8f42fd80eff7309a97a4";
    src = fetchgit {
      url = "https://github.com/bugen/pypipe";
      rev = "3da3c1020117b1dad6fa8f42fd80eff7309a97a4";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-fyadMTG+jVfAUf1j0gZEyL+HB07e6ulxA//6uPCYIAI=";
    };
    date = "2023-11-02";
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
    version = "9.19.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/9.19.0/simple-icons-font-9.19.0.zip";
      sha256 = "sha256-BrD+o0zzBmf0vgcm29j/6JpD2evv22hbZbk1AgTaa3A=";
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
    version = "v4.11.2";
    src = fetchFromGitHub {
      owner = "telegramdesktop";
      repo = "tdesktop";
      rev = "v4.11.2";
      fetchSubmodules = true;
      sha256 = "sha256-Hjg349h9dlBfKVLIPDqPP8U+Yt0Iaeyjq6hsUB5+zYM=";
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
    version = "be70a6c68a83a252a20fd853344e3c2e62775fa0";
    src = fetchFromGitHub {
      owner = "loyalsoldier";
      repo = "v2ray-rules-dat";
      rev = "be70a6c68a83a252a20fd853344e3c2e62775fa0";
      fetchSubmodules = false;
      sha256 = "sha256-tGuVVsUJb2TW9zT4HGNsUS8V1zZV6n21SL45DMWfTI0=";
    };
    date = "2023-11-01";
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
    version = "df8cdf68234fbf056202a9684931c3dfa89988c1";
    src = fetchgit {
      url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
      rev = "df8cdf68234fbf056202a9684931c3dfa89988c1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-rJOWVz1cplThmx9HY7RqYSxUgKKq1yjzhS4Pb2ebFQ4=";
    };
    date = "2023-10-29";
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
    version = "2.9.2";
    src = fetchFromGitHub {
      owner = "muety";
      repo = "wakapi";
      rev = "2.9.2";
      fetchSubmodules = false;
      sha256 = "sha256-BRIcStqRzwoFG9HkWBpfumeCzbrSI0Hg//a0iDQtNw8=";
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
    version = "v0.38.2";
    src = fetchFromGitHub {
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.38.2";
      fetchSubmodules = false;
      sha256 = "sha256-rq7M4g+s44j9jh5GzOjOCBr7VK3m/EQej/Qcnp67NhY=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.38.2/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
