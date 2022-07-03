{ source, stdenv, lib }:
stdenv.mkDerivation rec {
  inherit (source) pname version src;

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
