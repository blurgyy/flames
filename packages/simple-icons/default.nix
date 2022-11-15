{ source, stdenv, lib
, unzip
}: stdenv.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';
  installPhase = ''
    install -Dm644 -t $out/share/fonts/opentype font/SimpleIcons.otf 
    install -Dm644 -t $out/share/fonts/truetype font/SimpleIcons.ttf 
  '';

  meta = {
    homepage = "https://github.com/simple-icons/simple-icons-font";
    description = "SVG icon font for popular brands";
    license = lib.licenses.cc0;
  };
}
