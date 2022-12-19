{ source, stdenv, lib }: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm644 $src/dist/codicon.ttf $out/share/fonts/truetype/codicon.ttf
    install -Dvm644 -t $out/share/doc/${pname} $src/dist/codicon.{css,csv,html,svg}
  '';

  meta = {
    homepage = "https://github.com/microsoft/${pname}";
    description = "The icon font for Visual Studio Code";
    license = lib.licenses.cc-by-nc-sa-40;
  };
}
