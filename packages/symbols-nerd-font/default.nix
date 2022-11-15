{ source, stdenv, lib
, unzip
}: stdenv.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';
  installPhase = ''
    install -Dm644 'Symbols-2048-em Nerd Font Complete.ttf' $out/share/fonts/truetype/'Symbols-2048-em Nerd Font Complete.ttf'
  '';

  meta = {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "Iconic font";
    license = lib.licenses.mit;
  };
}
