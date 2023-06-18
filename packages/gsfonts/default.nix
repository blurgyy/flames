{ source, stdenvNoCC, lib
, util-linux
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ util-linux ];
  # REF: <https://archlinux.org/packages/extra/any/gsfonts/>
  installPhase = ''
    install -Dvm444 -t $out/share/fonts/opentype $src/fonts/*.otf
    for fc in $src/fontconfig/*.conf; do
      install -Dvm444 $fc $out/etc/fonts/conf.d/69-''${fc##*/}
    done
  '';

  meta = {
    homepage = "https://github.com/ArtifexSoftware/urw-base35-fonts";
    description = "fonts from ghostscriptX";
    license = lib.licenses.agpl3;
  };
}
