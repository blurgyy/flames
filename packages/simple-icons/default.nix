{ source, stdenvNoCC, lib
, unzip
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [ unzip ];

  buildCommand = ''
    unzip $src
    install -Dvm644 -t $out/share/fonts/opentype font/SimpleIcons.otf 
    install -Dvm644 -t $out/share/fonts/truetype font/SimpleIcons.ttf 
  '';

  meta = {
    homepage = "https://github.com/simple-icons/simple-icons-font";
    description = "SVG icon font for popular brands";
    license = lib.licenses.cc0;
  };
}
