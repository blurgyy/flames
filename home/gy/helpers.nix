{ pkgs, lib }: with builtins; rec {
  mergeAttrsList = attrList: foldl' (x: y: x // y) {} attrList;

  forest = pkgs.fetchurl {
    url = "https://i.redd.it/a8kxowakxbe81.jpg";
    name = "forest.jpg";
    hash = "sha256-DINHeFo3VZbgVEUlJ/lvThvR5KWRXyKoNo6Eo2jLYDw=";
  };
  cozy = pkgs.fetchurl {
    url = "https://i.redd.it/0oui0mtf451a1.jpg";
    name = "cozy.jpg";
    hash = "sha256-L5v9S6aXo4fbEZOHLnIC04xJc6C0/pW8S8sXF+GW7rY=";
  };
  cats = pkgs.fetchurl {
    url = "https://i.redd.it/3wdudrbvap0a1.png";
    name = "cats.png";
    hash = "sha256-zkbzVUjhixbiiE7N8uvVuIbTdU79XWy57tY19ZlwTBU";
  };
  gateway = pkgs.fetchurl {
    url = "https://i.redd.it/iau1mmmtig991.jpg";
    name = "gateway.jpg";
    hash = "sha256-PDkbNlvzB5MBcm0Z74vBLaCM0Qf+D6E6k9IJ14FK+7c=";
  };
  winter = pkgs.fetchurl {
    url = "https://i.redd.it/mqjnbna9y53a1.jpg";
    name = "winter.jpg";
    hash = "sha256-JDXYkEaCeHsIft34uwkk6eJcNN9NgSLkM9JqM+ocnNs=";
  };

  ricing.wallpaper = cozy;

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

  catppuccinColor = name: let
    colors = {
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
  in
    colors."${name}";

  ricing.themeColor = name: let
    colors = {
      background = catppuccinColor "base";
      foreground = catppuccinColor "text";

      black = catppuccinColor "crust";
      white = catppuccinColor "rosewater";
      gray = catppuccinColor "overlay0";
      lightgray = catppuccinColor "overlay2";
      darkgray = catppuccinColor "surface1";

      red = catppuccinColor "red";
      green = catppuccinColor "green";
      blue = catppuccinColor "blue";
      cyan = catppuccinColor "sky";
      yellow = catppuccinColor "yellow";
      orange = catppuccinColor "peach";
      purple = catppuccinColor "mauve";
      pink = catppuccinColor "pink";
    };
  in
    colors."${name}";

  mirrorDirsAsXdg = let
    loadFile = with builtins; path: if lib.hasSuffix ".asnix" path
      then let
        f = import path;
        type = typeOf f;
      in if type == "lambda"
        then let
            args = (intersectAttrs (functionArgs f) { inherit pkgs lib ricing; });
          in f args
        else f
      else readFile path;
    mirrorSingleDirAsXdgInner = pathPrefix: path: mapAttrs
        (subPath: type:
          if type == "regular" then
            {
              name = "${path}/${lib.removeSuffix ".asnix" subPath}";
              value = {
                text = loadFile (pathPrefix + "/${path}/${subPath}");
                # setting force=true will unconditionally replace target path
                force = true;  # REF: https://github.com/nix-community/home-manager/issues/6#issuecomment-693001293
              };
            }
          else
            (mirrorSingleDirAsXdgInner pathPrefix "${path}/${subPath}")
        )
        (readDir (pathPrefix + "/${path}"));
    mirrorDirAsXdg = pathPrefix: path: listToAttrs (lib.collect
      (x: x ? name && x ? value)
      (mirrorSingleDirAsXdgInner pathPrefix path));
  in
    pathPrefix: paths: mergeAttrsList (map
      (path: mirrorDirAsXdg pathPrefix path)
      paths);
  manifestXdgConfigFilesFrom = dir: mirrorDirsAsXdg dir (map
    (path: lib.last (lib.splitString "/" path))
    (attrNames (readDir dir)));
}
