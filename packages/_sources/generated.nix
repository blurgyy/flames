# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
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
    version = "8d0b07ad927f976708a1f875eb9aacaf67876137";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "fish";
      rev = "8d0b07ad927f976708a1f875eb9aacaf67876137";
      fetchSubmodules = false;
      sha256 = "sha256-/JIKRRHjaO2jC0NNPBiSaLe8pR2ASv24/LFKOJoZPjk=";
    });
    date = "2022-11-18";
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
    version = "202211212211";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202211212211/geoip.dat";
      sha256 = "sha256-aw9PSSFcul7YZsw8Tqc2GRJLc0sm//A7fRf+M2ZJfhg=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202211212211";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202211212211/geosite.dat";
      sha256 = "sha256-D1ZYpxNNh7U+kCBMq8onQ+++Q1J66IvGmv+iFHnOr+g=";
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
    version = "2022-11";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2022-11.csv.gz";
      sha256 = "sha256-0uCyjNWPlkc+YquPdvn4t4LX3FGjxxfw2p+oz1z8Dy0=";
    };
  };
  rustdesk-server = {
    pname = "rustdesk-server";
    version = "1.1.6-1";
    src = fetchFromGitHub ({
      owner = "rustdesk";
      repo = "rustdesk-server";
      rev = "1.1.6-1";
      fetchSubmodules = false;
      sha256 = "sha256-21PHplA0PGdXXakyt+50KFJHLpMvSBUqHnIxdYNnaB4=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./rustdesk-server-1.1.6-1/Cargo.lock;
      outputHashes = {
        "confy-0.4.0" = "sha256-e91cvEixhpPzIthAxzTa3fDY6eCsHUy/eZQAqs7QTDo=";
        "async-speed-limit-0.3.1" = "sha256-iOel6XA07RPrBjQAFLnxXX4VBpDrYZaqQc9clnsOorI=";
        "tokio-socks-0.5.1" = "sha256-inmAJk0fAlsVNIwfD/M+htwIdQHwGSTRrEy6N/mspMI=";
      };
    };
  };
  simple-icons = {
    pname = "simple-icons";
    version = "7.20.0";
    src = fetchurl {
      url = "https://github.com/simple-icons/simple-icons-font/releases/download/7.20.0/simple-icons-font-7.20.0.zip";
      sha256 = "sha256-9k+PWzbZc31SZMeHhkkXK+1moMH9dU07JTjZdrdUa80=";
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
    version = "d9e5c6d1e3b2c6f6f344f7663691c4c8e7ebeb4c";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "tmux";
      rev = "d9e5c6d1e3b2c6f6f344f7663691c4c8e7ebeb4c";
      fetchSubmodules = false;
      sha256 = "sha256-k0nYjGjiTS0TOnYXoZg7w9UksBMLT+Bq/fJI3f9qqBg=";
    });
    date = "2022-10-17";
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
    version = "2.5.3";
    src = fetchFromGitHub ({
      owner = "muety";
      repo = "wakapi";
      rev = "2.5.3";
      fetchSubmodules = false;
      sha256 = "sha256-KwOPIMtmy7ldNi34te0KY5RNIFfb7wOl/lVe+a7t/a0=";
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
    version = "v0.33.0";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.33.0";
      fetchSubmodules = false;
      sha256 = "sha256-u+D7DKa2hb6kd6LPcJydkkChsPKW101bJWXx6C87rPs=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.33.0/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
