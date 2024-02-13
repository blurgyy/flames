{ source, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm444 $src $out
  '';
}
