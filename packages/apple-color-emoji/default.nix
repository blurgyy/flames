{ source, stdenv, lib, ... }: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/AppleColorEmoji.ttf
  '';

  meta = {
    homepage = "https://github.com/samuelngs/${pname}";
    description = "Apple Color Emoji for Linux";
    license = lib.licenses.asl20;
  };
}
