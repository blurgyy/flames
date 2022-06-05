rec {
  env = {
    TERM = "xterm-256color";
  };
  window = {
    decorations = "full";
    startup_mode = "Maximized";
    title = "Alacritty";
    gtk_theme_variant = null;
  };

  font = {
    normal = {
      family = "monospace";
    };
    bold = {
      family = "monospace";
      style = "Bold";
    };
    italic = {
      family = "monospace";
      style = "Italic";
    };
    bold_italic = {
      family = "monospace";
      style = "Bold Italic";
    };
    size = 15;
  };

  schemes = {
    gruvbox_dark = {
      primary = {
        background = "0x1d2021";
        foreground = "0xebdbb2";
      };
      normal = {
        black = "0x282828";
        red = "0xcc241d";
        green = "0x98971a";
        yellow = "0xd79921";
        blue = "0x458588";
        magenta = "0xb16286";
        cyan = "0x689d6a";
        white = "0xa89984";
      };
      bright = {
        black = "0x928374";
        red = "0xfb4934";
        green = "0xb8bb26";
        yellow = "0xfabd2f";
        blue = "0x83a598";
        magenta = "0xd3869b";
        cyan = "0x8ec07c";
        white = "0xebdbb2";
      };
    };
    gruvbox_light = {
      primary = {
        background = "0xfbf1c7";
        foreground = "0x3c3836";
      };
      normal = {
        black = "0xfbf1c7";
        red = "0xcc241d";
        green = "0x98971a";
        yellow = "0xd79921";
        blue = "0x458588";
        magenta = "0xb16286";
        cyan = "0x689d6a";
        white = "0x7c6f64";
      };
      bright = {
        black = "0x928374";
        red = "0x9d0006";
        green = "0x79740e";
        yellow = "0xb57614";
        blue = "0x076678";
        magenta = "0x8f3f71";
        cyan = "0x427b58";
        white = "0x3c3836";
      };
    };

    iceberg_dark = {
      primary = {
        background = "0x161821";
        foreground = "0xd2d4de";
      };
      normal = {
        black = "0x161821";
        red = "0xe27878";
        green = "0xb4be82";
        yellow = "0xe2a478";
        blue = "0x84a0c6";
        magenta = "0xa093c7";
        cyan = "0x89b8c2";
        white = "0xc6c8d1";
      };
      bright = {
        black = "0x6b7089";
        red = "0xe98989";
        green = "0xc0ca8e";
        yellow = "0xe9b189";
        blue = "0x91acd1";
        magenta = "0xada0d3";
        cyan = "0x95c4ce";
        white = "0xd2d4de";
      };
    };
    iceberg_light = {
      primary = {
        background = "0xe8e9ec";
        foreground = "0x33374c";
      };
      normal = {
        black = "0xdcdfe7";
        red = "0xcc517a";
        green = "0x668e3d";
        yellow = "0xc57339";
        blue = "0x2d539e";
        magenta = "0x7759b4";
        cyan = "0x3f83a6";
        white = "0x33374c";
      };
      bright = {
        black = "0x8389a3";
        red = "0xcc3768";
        green = "0x598030";
        yellow = "0xb6662d";
        blue = "0x22478e";
        magenta = "0x6845ad";
        cyan = "0x327698";
        white = "0x262a3f";
      };
    };

    nord = {
      primary = {
        background = "0x2e3440";
        foreground = "0xd8dee9";
        dim_foreground = "0xa5abb6";
      };
      cursor = {
        text = "0x2e3440";
        cursor = "0xd8dee9";
      };
      vi_mode_cursor = {
        text = "0x2e3440";
        cursor = "0xd8dee9";
      };
      selection = {
        text = "CellForeground";
        background = "0x4c566a";
      };
      search = {
        matches = {
          foreground = "CellBackground";
          background = "0x88c0d0";
        };
        bar = {
          background = "0x434c5e";
          foreground = "0xd8dee9";
        };
      };
      normal = {
        black = "0x3b4252";
        red = "0xbf616a";
        green = "0xa3be8c";
        yellow = "0xebcb8b";
        blue = "0x81a1c1";
        magenta = "0xb48ead";
        cyan = "0x88c0d0";
        white = "0xe5e9f0";
      };
      bright = {
        black = "0x4c566a";
        red = "0xbf616a";
        green = "0xa3be8c";
        yellow = "0xebcb8b";
        blue = "0x81a1c1";
        magenta = "0xb48ead";
        cyan = "0x8fbcbb";
        white = "0xeceff4";
      };
      dim = {
        black = "0x373e4d";
        red = "0x94545d";
        green = "0x809575";
        yellow = "0xb29e75";
        blue = "0x68809a";
        magenta = "0x8c738c";
        cyan = "0x6d96a5";
        white = "0xaeb3bb";
      };
    };

    kanawaga = {
      primary = {
        background = "0x1f1f28";
        foreground = "0xdcd7ba";
      };
      normal = {
        black = "0x090618";
        red = "0xc34043";
        green = "0x76946a";
        yellow = "0xc0a36e";
        blue = "0x7e9cd8";
        magenta = "0x957fb8";
        cyan = "0x6a9589";
        white = "0xc8c093";
      };
      bright = {
        black = "0x727169";
        red = "0xe82424";
        green = "0x98bb6c";
        yellow = "0xe6c384";
        blue = "0x7fb4ca";
        magenta = "0x938aa9";
        cyan = "0x7aa89f";
        white = "0xdcd7ba";
      };
      selection = {
        background = "0x2d4f67";
        foreground = "0xc8c093";
      };
    };

    catppuccin = {
      primary = {
        background = "0x1E1D2F";
        foreground = "0xD9E0EE";
      };
      cursor = {
        text = "0x1E1D2F";
        cursor = "0xF5E0DC";
      };
      normal = {
        black = "0x6E6C7E";
        red = "0xF28FAD";
        green = "0xABE9B3";
        yellow = "0xFAE3B0";
        blue = "0x96CDFB";
        magenta = "0xF5C2E7";
        cyan = "0x89DCEB";
        white = "0xD9E0EE";
      };
      bright = {
        black = "0x988BA2";
        red = "0xF28FAD";
        green = "0xABE9B3";
        yellow = "0xFAE3B0";
        blue = "0x96CDFB";
        magenta = "0xF5C2E7";
        cyan = "0x89DCEB";
        white = "0xD9E0EE";
      };
      indexed_colors = [
        { index = 16; color = "0xF8BD96"; }
        { index = 17; color = "0xF5E0DC"; }
      ];
    };
  };

  colors = schemes.catppuccin;
}
