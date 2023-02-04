{ source, stdenvNoCC, lib
, unzip
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [ unzip ];

  buildCommand = ''
    unzip $src
    install -Dvm644 'Symbols-2048-em Nerd Font Complete.ttf' $out/share/fonts/truetype/'Symbols-2048-em Nerd Font Complete.ttf'
  '';

  meta = {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "Iconic font";
    license = lib.licenses.mit;
  };
}
