{ stdenv, pkgs }: with pkgs;
stdenv.mkDerivation {
  pname = "notification-scripts";
  version = "0.0.0";
  src = ./src;
  phases = [ "installPhase" ];

  # NOTE: Need these for `substituteAllInPlace` to work
  inherit bash light dunst slurp grim imagemagick wl-clipboard flameshot pamixer coreutils;

  installPhase = ''
    install -Dt $out/bin -m555 $src/*
    for script in $out/bin/*; do
      substituteAllInPlace $script
    done
  '';
}
