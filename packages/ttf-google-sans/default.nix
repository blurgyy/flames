{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm644 $src/GoogleSans-*.ttf -t $out/share/fonts/truetype
  '';
}
