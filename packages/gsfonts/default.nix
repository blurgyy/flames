{ source, stdenv, lib
, util-linux
}: stdenv.mkDerivation {
  inherit (source) pname version src;

  nativeBuildInputs = [ util-linux ];
  installPhase = ''
    # REF: <https://archlinux.org/packages/extra/any/gsfonts/>
    mkdir -p $out/share/{fonts/postscript,fontconfig/conf.{avail,default}} $out/etc/fonts/conf.d
    cp $src/fonts/*.otf $out/share/fonts/postscript
    for fc in $src/fontconfig/*.conf; do
      cp $fc $out/share/fontconfig/conf.avail/69-''${fc##*/}
    done
    ln -s $out/share/fontconfig/conf.avail/* $out/share/fontconfig/conf.default
    ln -s $out/share/fontconfig/conf.avail/* $out/etc/fonts/conf.d
  '';

  meta = {
    homepage = "https://github.com/ArtifexSoftware/urw-base35-fonts";
    description = "fonts from ghostscriptX";
    license = lib.licenses.agpl3;
  };
}
