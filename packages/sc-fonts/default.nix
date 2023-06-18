{ source, lib, stdenvNoCC
, findutils
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ findutils ];

  installPhase = ''
    install -Dvm444 -t $out/share/fonts/opentype $(find $src -iname '*.otf')
    install -Dvm444 -t $out/share/fonts/truetype $(find $src -iname '*.ttf' -o -iname '*.ttc')
  '';

  meta = {
    homepage = "https://github.com/Haixing-Hu/latex-chinese-fonts";
    description = "Simplified Chinese fonts for the LaTeX typesetting. ";
    license = lib.licenses.mit;
  };
}
