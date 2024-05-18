{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation rec {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm444 $src $out/share/fonts/truetype/codicon.ttf
  '';

  meta = {
    homepage = "https://github.com/microsoft/${pname}";
    description = "The icon font for Visual Studio Code";
    license = lib.licenses.cc-by-nc-sa-40;
  };
}
