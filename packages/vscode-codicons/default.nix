{ source, stdenv, lib, ... }:
stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/truetype $src/dist/codicon.ttf
    install -Dt $out/share/doc/${pname} $src/dist/codicon.{css,csv,html,svg}
  '';

  meta = {
    homepage = "https://github.com/microsoft/${pname}";
    description = "The icon font for Visual Studio Code";
    license = lib.licenses.cc-by-nc-sa-40;
  };
}
