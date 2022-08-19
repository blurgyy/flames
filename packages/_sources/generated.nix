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
  lsp-format-nvim = {
    pname = "lsp-format-nvim";
    version = "v2.4.1";
    src = fetchFromGitHub ({
      owner = "lukas-reineke";
      repo = "lsp-format.nvim";
      rev = "v2.4.1";
      fetchSubmodules = false;
      sha256 = "sha256-xFA+9JO3Rnj/CAYXb+oOnbslH3jgEapHA67I6dMFRFI=";
    });
  };
  rathole = {
    pname = "rathole";
    version = "v0.4.3";
    src = fetchFromGitHub ({
      owner = "rapiz1";
      repo = "rathole";
      rev = "v0.4.3";
      fetchSubmodules = false;
      sha256 = "sha256-gqWgx03mUk6+9K4Yw5PHEBwFxsOR+48wvngT+wQnN1k=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./rathole-v0.4.3/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  symbols-nerd-font = {
    pname = "symbols-nerd-font";
    version = "v2.1.0";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf";
      sha256 = "sha256-32vlj3cHwOjJvDqiMPyY/o+njPuhytQzIeWSgeyklgA=";
    };
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
  zellij-hirr = {
    pname = "zellij-hirr";
    version = "v0.31.3";
    src = fetchFromGitHub ({
      owner = "zellij-org";
      repo = "zellij";
      rev = "v0.31.3";
      fetchSubmodules = false;
      sha256 = "sha256-4iljPNw/tS/COStARg2PlrCoeE0lkSQ5+r8BrnxFLMo=";
    });
  };
}
