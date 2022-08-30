{ source, stdenv, lib
, unzip
}: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "unpackPhase" "installPhase" ];
  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';
  installPhase = ''
    install -Dt $out/share/truetype -m444 'Symbols-2048-em Nerd Font Complete.ttf'
  '';

  meta = {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "Iconic font";
    license = lib.licenses.mit;
  };
}
