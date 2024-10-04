{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  name = "xkb-layouts";
  src = ./src;

  buildCommand = ''
    install -Dvm444 $src/* -t $out/share/X11/xkb/symbols
  '';
}
