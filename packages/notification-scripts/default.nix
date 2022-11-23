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
  phases = [ "installPhase" ];

  # NOTE: Need these for `substituteAllInPlace` to work
  inherit bash light dunst slurp grim imagemagick flameshot pamixer coreutils;

  installPhase = ''
    install -Dt $out/bin -m555 $src/*
    for script in $out/bin/*; do
      substituteAllInPlace $script
      substituteInPlace $script --replace @wl-clipboard@ ${wl-clipboard}
    done
  '';
}
