{ source, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  installPhase = ''
    install -Dvm444 -t $out/share/fonts/opentype $src/**/*.{otf,OTF}
    install -Dvm444 -t $out/share/fonts/truetype $src/**/*.{ttf,ttc,TTF,TTC}
  '';

  meta.homepage = "https://github.com/blurgyy/fonts";
}
