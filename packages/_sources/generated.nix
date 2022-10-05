# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
  apple-color-emoji = {
    pname = "apple-color-emoji";
    version = "ios-15.4";
    src = fetchurl {
      url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/ios-15.4/AppleColorEmoji.ttf";
      sha256 = "sha256-CDmtLCzlytCZyMBDoMrdvs3ScHkMipuiXoNfc6bfimw=";
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
    version = "fc840f3262e080e2bcc0347c0d0f16a7d558d76f";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "fish";
      rev = "fc840f3262e080e2bcc0347c0d0f16a7d558d76f";
      fetchSubmodules = false;
      sha256 = "sha256-aweKiR9X1aOgTo7By+UvBTCLUOsTcsWwBO7pAzsl0Kk=";
    });
    date = "2022-09-27";
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
    version = "202210042214";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202210042214/geoip.dat";
      sha256 = "sha256-qs6nzb8LiYEbkfAFfqK7pEDWM/xqXS+nYpN0FZAVycg=";
    };
  };
  loyalsoldier-geosite = {
    pname = "loyalsoldier-geosite";
    version = "202210042214";
    src = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202210042214/geosite.dat";
      sha256 = "sha256-x54erVwzLKzJ+Cn3qYxBahguAmI6uNnLBHuT7D08JF0=";
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
    version = "2022-10";
    src = fetchurl {
      url = "https://download.db-ip.com/free/dbip-country-lite-2022-10.csv.gz";
      sha256 = "sha256-w3Q+nPOgFB3AJkzsskbw5w0O6INFY5Mz9Qiekud/fnU=";
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
    version = "bd1ea4b86a159faddbb049e6be8082217348234d";
    src = fetchFromGitHub ({
      owner = "catppuccin";
      repo = "tmux";
      rev = "bd1ea4b86a159faddbb049e6be8082217348234d";
      fetchSubmodules = false;
      sha256 = "sha256-Mf+aTMJyViFIT2bz/CgWg5Oqfc3+yx69rehFt1HLKL4=";
    });
    date = "2022-10-01";
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
    version = "fd0390cfa59c25cd71b80440052498ddd6764160";
    src = fetchFromGitHub ({
      owner = "black-desk";
      repo = "fcitx5-ui.nvim";
      rev = "fd0390cfa59c25cd71b80440052498ddd6764160";
      fetchSubmodules = false;
      sha256 = "sha256-zeCLbSfkpv/2wq73+Ji5kTmJVt9zK0tWTwBpOXeXgCw=";
    });
    date = "2022-04-19";
  };
  vim-plugin-nvim-navic = {
    pname = "vim-plugin-nvim-navic";
    version = "132b273773768b36e9ecab2138b82234a9faf5ed";
    src = fetchFromGitHub ({
      owner = "SmiteshP";
      repo = "nvim-navic";
      rev = "132b273773768b36e9ecab2138b82234a9faf5ed";
      fetchSubmodules = false;
      sha256 = "sha256-OzzH/DNZk2g8HPbYw6ulM+ScxQW6NU3YZxTgLycWQOM=";
    });
    date = "2022-09-30";
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
    version = "2.4.0";
    src = fetchFromGitHub ({
      owner = "muety";
      repo = "wakapi";
      rev = "2.4.0";
      fetchSubmodules = false;
      sha256 = "sha256-XXjdCDukvKYQVeQAC6uZaDU8QUCzUFQSRdE2m6H745g=";
    });
  };
  xtables-addons-perl-scripts = {
    pname = "xtables-addons-perl-scripts";
    version = "3.21";
    src = fetchurl {
      url = "https://inai.de/files/xtables-addons/xtables-addons-3.21.tar.xz";
      sha256 = "sha256-LgmsEpoU9enCOxFevN//SqhOKuuhJo2985stdSvXHhk=";
    };
  };
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.31.4";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.31.4";
      fetchSubmodules = false;
      sha256 = "sha256-eULdBwQNquk4jj1SjdMsAN7S7mBSZs7jVAwMyFvOlWk=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./zellij-hirr-v0.31.4/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
