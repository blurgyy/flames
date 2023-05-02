{ source, lib, stdenvNoCC
, unzip
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ unzip ];

  buildCommand = ''
    unzip $src
    install -Dvm644 SymbolsNerdFontMono-Regular.ttf $out/share/fonts/truetype/SymbolsNerdFontMono-Regular.ttf
    install -Dvm644 SymbolsNerdFont-Regular.ttf $out/share/fonts/truetype/SymbolsNerdFont-Regular.ttf
  '';

  meta = {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "Iconic font";
    license = lib.licenses.mit;
  };
}
