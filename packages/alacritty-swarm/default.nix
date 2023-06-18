{ stdenvNoCC
, bash
, alacritty
, lsof
}: stdenvNoCC.mkDerivation {
  name = "alacritty-swarm";
  src = ./alacritty;

  inherit bash alacritty lsof;

  buildCommand = ''
    install -Dvm555 $src $out/bin/alacritty
    substituteAllInPlace $out/bin/alacritty
    install -Dvm444 ${alacritty}/share/applications/Alacritty.desktop $out/share/applications/Alacritty.desktop
  '';
}
