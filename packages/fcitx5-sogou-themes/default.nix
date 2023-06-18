{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    cd $src
    for i in *; do
      if [[ -f "$i" ]]; then continue; fi
      install -Dvm444 -t "$out/share/fcitx5/themes/$i" "$i"/*
    done
  '';

  meta = {
    homepage = "https://github.com/sxqsfun/fcitx5-sogou-themes";
    description = "Fcitx5 themes converted from sogou pinyin";
    license = lib.licenses.unfreeRedistributable;
  };
}
