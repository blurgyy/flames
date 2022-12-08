{ stdenv
, bash
, alacritty
, lsof
}: stdenv.mkDerivation {
  name = "alacritty-swarm";
  src = ./alacritty;
  phases = [ "installPhase" ];

  inherit bash alacritty lsof;

  installPhase = ''
    install -Dm555 $src $out/bin/alacritty
    substituteAllInPlace $out/bin/alacritty
    install -Dm 444 ${alacritty}/share/applications/Alacritty.desktop $out/share/applications/Alacritty.desktop
  '';
}
