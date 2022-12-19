{ stdenv
, bash
, alacritty
, lsof
}: stdenv.mkDerivation {
  name = "alacritty-swarm";
  src = ./alacritty;

  inherit bash alacritty lsof;

  buildCommand = ''
    install -Dvm755 $src $out/bin/alacritty
    substituteAllInPlace $out/bin/alacritty
    install -Dvm644 ${alacritty}/share/applications/Alacritty.desktop $out/share/applications/Alacritty.desktop
  '';
}
