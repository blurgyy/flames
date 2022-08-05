{ source, stdenv }: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -dm755 $out/share/fcitx5/themes
    for i in "$src"/*; do
      if [[ $i == */readme.md ]]; then continue; fi
      cp -rv $i $out/share/fcitx5/themes
    done
  '';

  meta = {
    homepage = "https://github.com/sxqsfun/fcitx5-sogou-themes";
    description = "Fcitx5 themes converted from sogou pinyin";
    license = null;
  };
}
