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
  async-speed-limit-tokio1 = {
    pname = "async-speed-limit-tokio1";
    version = "8d1851d967b1014eb263bae23053a0e513431a9f";
    src = fetchFromGitHub ({
      owner = "open-trade";
      repo = "async-speed-limit";
      rev = "8d1851d967b1014eb263bae23053a0e513431a9f";
      fetchSubmodules = false;
      sha256 = "sha256-OCO8sYXPbMUTUlGW2F7I0jsjCic+jHKnC8qEh+1Kll4=";
    });
    date = "2022-07-14";
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
    version = "v0.2.0";
    src = fetchFromGitHub ({
      owner = "blurgyy";
      repo = "libime-history-merge";
      rev = "v0.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-k8I/uUFjqUecPgsrJl+X8tZajkfdW35ahMSJeZZn8jY=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./libime-history-merge-v0.2.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  loyalsoldier-geoip = {
    pname = "loyalsoldier-geoip";
    version = "202212282209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202212282209/geoip.dat";
      sha256 = "sha256-y7KZZ94MFOiBCd3atv5IdGBsdWvIejHTCLM5pz39v6U=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202212282209";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202212282209/geosite.dat";
      sha256 = "sha256-iEDDUDGIKxyLwBuVranpShbqDwv+OfRAtU3n39zrU38=";
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
    version = "2022-12";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2022-12.csv.gz";
      sha256 = "sha256-tcbxYUMIP7DfLYo0phIL7qN9f/xOdMMS2SNR0Mx6Gvw=";
    };
  };
  rustdesk-server = {
    pname = "rustdesk-server";
    version = "1.1.6-2";
    src = fetchFromGitHub ({
      owner = "rustdesk";
      repo = "rustdesk-server";
      rev = "1.1.6-2";
      fetchSubmodules = false;
      sha256 = "sha256-Bcl3PREvr76qIvuPC4wxd6HBXG9Xw4sJapaY3B/DGbY=";
    });
  };
  simple-icons = {
    pname = "simple-icons";
    version = "8.2.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/8.2.0/simple-icons-font-8.2.0.zip";
      sha256 = "sha256-S703EqzJEoS6ekSCrjmWgSbcPGKc1VBqirVBXvE342Q=";
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v2.2.2";
    src = fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/NerdFontsSymbolsOnly.zip";
      sha256 = "sha256-/xugzPGY3ZKoDcpI5l8hG/f2s4dAMnhRyZtTEyhcadk=";
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
    version = "72a93f81a270b38f94fcc784500fba69556f43d6";
    src = fetchFromGitHub ({
      owner = "black-desk";
      repo = "fcitx5-ui.nvim";
      rev = "72a93f81a270b38f94fcc784500fba69556f43d6";
      fetchSubmodules = false;
      sha256 = "sha256-/LblTpv8ZMZ7iXH/mYrDAwWDKNrBHt6eOua5OX0zRYg=";
    });
    date = "2022-10-09";
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
    version = "2.5.4";
    src = fetchFromGitHub ({
      owner = "muety";
      repo = "wakapi";
      rev = "2.5.4";
      fetchSubmodules = false;
      sha256 = "sha256-IWTSxfpJ1zQImo6rxnSPgGte83VSRrF7Bkhv2r6KkRo=";
    });
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.22";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.22.tar.xz";
      sha256 = "sha256-+qFqJxZida+/6N9gX1XDqBrGk78Z2mdNRc7e1BN64hc=";
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
