{ stdenv, lib, fetchurl, ... }:
stdenv.mkDerivation rec {
  pname = "symbols-nerd-font";
  version = "2.1.0";
  src = fetchurl {
    name = "Symbols-2048-em Nerd Font Complete.ttf";
    url = "https://github.com/ryanoasis/nerd-fonts/blob/v${version}/src/glyphs/Symbols-2048-em%20Nerd%20Font%20Complete.ttf?raw=true";
    sha256 = "078ynwfl92p8pq1n3ic07248whdjm30gcvkq3sy9gas1vlpyg6an";
  };

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/truetype -m444 $src
  '';

  meta = {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "Iconic font";
    license = lib.licenses.mit;
  };
}
