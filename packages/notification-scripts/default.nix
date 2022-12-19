{ stdenv
, bash
, coreutils
, dunst
, flameshot
, grim
, imagemagick
, light
, pamixer
, slurp
, wl-clipboard
}: stdenv.mkDerivation {
  name = "notification-scripts";
  src = ./src;

  # NOTE: Need these for `substituteAllInPlace` to work
  inherit bash light dunst slurp grim imagemagick flameshot pamixer coreutils;

  buildCommand = ''
    install -Dvm755 -t $out/bin $src/*
    for script in $out/bin/*; do
      substituteAllInPlace $script
      substituteInPlace $script --replace @wl-clipboard@ ${wl-clipboard}
    done
  '';
}
