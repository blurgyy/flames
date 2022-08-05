{ source, stdenv, lib }: stdenv.mkDerivation {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -Dm644 $src/GoogleSans-*.ttf -t $out/share/fonts/TTF
  '';
}
