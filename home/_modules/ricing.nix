{ config, lib, pkgs, ... }: let
  cfg = config.ricing;

  # Wallpapers
  forest-8k = pkgs.fetchurl {
    url = "https://i.redd.it/a8kxowakxbe81.jpg";
    name = "forest.jpg";
    hash = "sha256-DINHeFo3VZbgVEUlJ/lvThvR5KWRXyKoNo6Eo2jLYDw=";
  };
  cozy-8k = pkgs.fetchurl {
    url = "https://i.redd.it/0oui0mtf451a1.jpg";
    name = "cozy.jpg";
    hash = "sha256-L5v9S6aXo4fbEZOHLnIC04xJc6C0/pW8S8sXF+GW7rY=";
  };
  cats-8k = pkgs.fetchurl {
    url = "https://i.redd.it/3wdudrbvap0a1.png";
    name = "cats.png";
    hash = "sha256-zkbzVUjhixbiiE7N8uvVuIbTdU79XWy57tY19ZlwTBU";
  };
  gateway-8k = pkgs.fetchurl {
    url = "https://i.redd.it/iau1mmmtig991.jpg";
    name = "gateway.jpg";
    hash = "sha256-PDkbNlvzB5MBcm0Z74vBLaCM0Qf+D6E6k9IJ14FK+7c=";
  };
  winter-4k = pkgs.fetchurl {
    url = "https://i.redd.it/mqjnbna9y53a1.jpg";
    name = "winter.jpg";
    hash = "sha256-JDXYkEaCeHsIft34uwkk6eJcNN9NgSLkM9JqM+ocnNs=";
  };

  # Colors;
  nordColor = id: let
    colors = {
      "0" = "#2e3440";
      "1" = "#3b4252";
      "2" = "#434c5e";
      "3" = "#4c566a";
      "4" = "#d8dee9";
      "5" = "#e5e9f0";
      "6" = "#eceff4";
      "7" = "#8fbcbb";
      "8" = "#88c0d0";
      "9" = "#81a1c1";
      "10" = "#5e81ac";
      "11" = "#bf616a";
      "12" = "#d08770";
      "13" = "#ebcb8b";
      "14" = "#a3be8c";
      "15" = "#b48ead";
    };
  in
    colors.${toString id};

  catppuccinColor = palette: name: let
    _ = {
      latte = {
        rosewater = "#dc8a78";
        flamingo = "#dd7878";
        pink = "#ea76cb";
        mauve = "#8839ef";
        red = "#d20f39";
        maroon = "#e64553";
        peach = "#fe640b";
        yellow = "#df8e1d";
        green = "#40a02b";
        teal = "#179299";
        sky = "#04a5e5";
        sapphire = "#209fb5";
        blue = "#1e66f5";
        lavender = "#7287fd";
        text = "#4c4f69";
        subtext1 = "#5c5f77";
        subtext0 = "#6c6f85";
        overlay2 = "#7c7f93";
        overlay1 = "#8c8fa1";
        overlay0 = "#9ca0b0";
        surface2 = "#acb0be";
        surface1 = "#bcc0cc";
        surface0 = "#ccd0da";
        base = "#eff1f5";
        mantle = "#e6e9ef";
        crust = "#dce0e8";
      };
      mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  in
    _.${palette}.${name};

  colors = colorFn: {
    background = colorFn "base";
    foreground = colorFn "text";

    black = colorFn "crust";
    highlight = colorFn "rosewater";
    gray = colorFn "overlay0";
    lightgray = colorFn "overlay2";
    darkgray = colorFn "surface1";

    red = colorFn "red";
    green = colorFn "green";
    blue = colorFn "blue";
    cyan = colorFn "sky";
    ocean = colorFn "sapphire";
    yellow = colorFn "yellow";
    orange = colorFn "peach";
    purple = colorFn "mauve";
    pink = colorFn "flamingo";
    magenta = colorFn "pink";
    teal = colorFn "teal";
    lavender = colorFn "lavender";
  };
in with lib; {
  options.ricing = {
    headful = {
      theme = mkOption { type = with types; nullOr (enum [ "light" "dark" ]); default = null; };
      wallpaper = mkOption { };
      themeColor = mkOption { };
    };
    textual = {
      theme = mkOption { type = with types; nullOr (enum [ "light" "dark" ]); default = null; };
      themeColor = mkOption { };
    };
  };

  config = {
    ricing = {
      headful = mkIf (cfg.headful != null) {
        wallpaper = cozy-8k;
        themeColor = name: let
          colorFn = catppuccinColor (if cfg.headful.theme == "light" then "latte" else "mocha");
        in
          (colors colorFn)."${name}";
      };
      textual.themeColor = mkIf (cfg.textual != null) (name: let
          colorFn = catppuccinColor (if cfg.textual.theme == "light" then "latte" else "mocha");
        in
          (colors colorFn)."${name}");
    };
    gtk = mkIf (cfg.headful != null) {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk.override {
          accents = [ "yellow" ];
          variant = if cfg.headful.theme == "light"
            then "latte"
            else "mocha";
        };
        name = if cfg.headful.theme == "light"
          then "Catppuccin-Latte-Standard-Yellow-Light"
          else "Catppuccin-Mocha-Standard-Yellow-Dark";
      };
      iconTheme = {
        package = pkgs.flat-remix-icon-theme-proper-trayicons;
        name = if cfg.headful.theme == "light"
          then "Flat-Remix-Yellow-Light"
          else "Flat-Remix-Yellow-Dark";
      };
    };
    programs.alacritty.settings.colors = builtins.fromJSON (readFile "${pkgs.alacritty-theme-catppuccin}/share/alacritty/themes/catppuccin-${
      if cfg.textual.theme == "light"
        then "latte"
        else "mocha"
    }.json");
    programs.bat.themes.catppuccin = readFile "${pkgs.bat-theme-catppuccin}/share/bat/themes/Catppuccin-${
      if cfg.textual.theme == "light"
        then "latte"
        else "mocha"
    }.tmTheme";
    programs.tmux.plugins = [{
      plugin = pkgs.tmux-plugin-catppuccin;
      extraConfig = "set -g @catppuccin_flavour '${if config.ricing.textual.theme == "light" then "latte" else "mocha"}'";
    }];
    services.dunst.iconTheme = config.gtk.iconTheme;
    # NOTE: Add `"layout.css.prefers-color-scheme.content-override" = 2;` to `Preferences` of
    # pacakge wrap options for firefox.
    # REF: <https://support.mozilla.org/bm/questions/1364502>

    home.activation.generateBatCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build
    '';
  };
}
