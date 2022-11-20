rec {
  env = {
    TERM = "xterm-256color";
  };
  window = {
    decorations = "full";
    startup_mode = "Maximized";
    title = "Alacritty";
    decorations_theme_variant = null;
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

    # $ cat alacritty.yaml | nix run nixpkgs#yj >tmp.json
    # $ nix repl
    # nix-repl > :p
    #            (builtins.fromJSON (builtins.readFile ./tmp.json)).scheme.<name>
    frappe = { bright = { black = "#626880"; blue = "#8CAAEE"; cyan = "#81C8BE"; green = "#A6D189"; magenta = "#F4B8E4"; red = "#E78284"; white = "#A5ADCE"; yellow = "#E5C890"; }; cursor = { cursor = "#F2D5CF"; text = "#303446"; }; dim = { black = "#51576D"; blue = "#8CAAEE"; cyan = "#81C8BE"; green = "#A6D189"; magenta = "#F4B8E4"; red = "#E78284"; white = "#B5BFE2"; yellow = "#E5C890"; }; hints = { end = { background = "#A5ADCE"; foreground = "#303446"; }; start = { background = "#E5C890"; foreground = "#303446"; }; }; indexed_colors = [ { color = "#EF9F76"; index = 16; } { color = "#F2D5CF"; index = 17; } ]; normal = { black = "#51576D"; blue = "#8CAAEE"; cyan = "#81C8BE"; green = "#A6D189"; magenta = "#F4B8E4"; red = "#E78284"; white = "#B5BFE2"; yellow = "#E5C890"; }; primary = { background = "#303446"; bright_foreground = "#C6D0F5"; dim_foreground = "#C6D0F5"; foreground = "#C6D0F5"; }; search = { focused_match = { background = "#A6D189"; foreground = "#303446"; }; footer_bar = { background = "#A5ADCE"; foreground = "#303446"; }; matches = { background = "#A5ADCE"; foreground = "#303446"; }; }; selection = { background = "#F2D5CF"; text = "#303446"; }; vi_mode_cursor = { cursor = "#BABBF1"; text = "#303446"; }; };
    latte = { bright = { black = "#6C6F85"; blue = "#1E66F5"; cyan = "#179299"; green = "#40A02B"; magenta = "#EA76CB"; red = "#D20F39"; white = "#BCC0CC"; yellow = "#DF8E1D"; }; cursor = { cursor = "#DC8A78"; text = "#EFF1F5"; }; dim = { black = "#5C5F77"; blue = "#1E66F5"; cyan = "#179299"; green = "#40A02B"; magenta = "#EA76CB"; red = "#D20F39"; white = "#ACB0BE"; yellow = "#DF8E1D"; }; hints = { end = { background = "#6C6F85"; foreground = "#EFF1F5"; }; start = { background = "#DF8E1D"; foreground = "#EFF1F5"; }; }; indexed_colors = [ { color = "#FE640B"; index = 16; } { color = "#DC8A78"; index = 17; } ]; normal = { black = "#5C5F77"; blue = "#1E66F5"; cyan = "#179299"; green = "#40A02B"; magenta = "#EA76CB"; red = "#D20F39"; white = "#ACB0BE"; yellow = "#DF8E1D"; }; primary = { background = "#EFF1F5"; bright_foreground = "#4C4F69"; dim_foreground = "#4C4F69"; foreground = "#4C4F69"; }; search = { focused_match = { background = "#40A02B"; foreground = "#EFF1F5"; }; footer_bar = { background = "#6C6F85"; foreground = "#EFF1F5"; }; matches = { background = "#6C6F85"; foreground = "#EFF1F5"; }; }; selection = { background = "#DC8A78"; text = "#EFF1F5"; }; vi_mode_cursor = { cursor = "#7287FD"; text = "#EFF1F5"; }; };
    macchiato = { bright = { black = "#5B6078"; blue = "#8AADF4"; cyan = "#8BD5CA"; green = "#A6DA95"; magenta = "#F5BDE6"; red = "#ED8796"; white = "#A5ADCB"; yellow = "#EED49F"; }; cursor = { cursor = "#F4DBD6"; text = "#24273A"; }; dim = { black = "#494D64"; blue = "#8AADF4"; cyan = "#8BD5CA"; green = "#A6DA95"; magenta = "#F5BDE6"; red = "#ED8796"; white = "#B8C0E0"; yellow = "#EED49F"; }; hints = { end = { background = "#A5ADCB"; foreground = "#24273A"; }; start = { background = "#EED49F"; foreground = "#24273A"; }; }; indexed_colors = [ { color = "#F5A97F"; index = 16; } { color = "#F4DBD6"; index = 17; } ]; normal = { black = "#494D64"; blue = "#8AADF4"; cyan = "#8BD5CA"; green = "#A6DA95"; magenta = "#F5BDE6"; red = "#ED8796"; white = "#B8C0E0"; yellow = "#EED49F"; }; primary = { background = "#24273A"; bright_foreground = "#CAD3F5"; dim_foreground = "#CAD3F5"; foreground = "#CAD3F5"; }; search = { focused_match = { background = "#A6DA95"; foreground = "#24273A"; }; footer_bar = { background = "#A5ADCB"; foreground = "#24273A"; }; matches = { background = "#A5ADCB"; foreground = "#24273A"; }; }; selection = { background = "#F4DBD6"; text = "#24273A"; }; vi_mode_cursor = { cursor = "#B7BDF8"; text = "#24273A"; }; };
    mocha = { bright = { black = "#585B70"; blue = "#89B4FA"; cyan = "#94E2D5"; green = "#A6E3A1"; magenta = "#F5C2E7"; red = "#F38BA8"; white = "#A6ADC8"; yellow = "#F9E2AF"; }; cursor = { cursor = "#F5E0DC"; text = "#1E1E2E"; }; dim = { black = "#45475A"; blue = "#89B4FA"; cyan = "#94E2D5"; green = "#A6E3A1"; magenta = "#F5C2E7"; red = "#F38BA8"; white = "#BAC2DE"; yellow = "#F9E2AF"; }; hints = { end = { background = "#A6ADC8"; foreground = "#1E1E2E"; }; start = { background = "#F9E2AF"; foreground = "#1E1E2E"; }; }; indexed_colors = [ { color = "#FAB387"; index = 16; } { color = "#F5E0DC"; index = 17; } ]; normal = { black = "#45475A"; blue = "#89B4FA"; cyan = "#94E2D5"; green = "#A6E3A1"; magenta = "#F5C2E7"; red = "#F38BA8"; white = "#BAC2DE"; yellow = "#F9E2AF"; }; primary = { background = "#1E1E2E"; bright_foreground = "#CDD6F4"; dim_foreground = "#CDD6F4"; foreground = "#CDD6F4"; }; search = { focused_match = { background = "#A6E3A1"; foreground = "#1E1E2E"; }; footer_bar = { background = "#A6ADC8"; foreground = "#1E1E2E"; }; matches = { background = "#A6ADC8"; foreground = "#1E1E2E"; }; }; selection = { background = "#F5E0DC"; text = "#1E1E2E"; }; vi_mode_cursor = { cursor = "#B4BEFE"; text = "#1E1E2E"; }; };
  };

  colors = schemes.mocha // { transparent_background_colors = true; };

  window.opacity = 0.75;
}
