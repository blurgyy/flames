{ stdenvNoCC
, bash
, alacritty
, lsof
}: stdenvNoCC.mkDerivation {
  pname = "alacritty-swarm";
  src = ./alacritty;
  inherit (alacritty) version;

  inherit bash alacritty lsof;

  buildCommand = ''
    install -Dvm555 $src $out/bin/alacritty
    substituteAllInPlace $out/bin/alacritty
    install -Dvm444 ${alacritty}/share/applications/Alacritty.desktop $out/share/applications/Alacritty.desktop
  '';
}
