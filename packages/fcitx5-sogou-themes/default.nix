{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "fcitx5-sogou-themes";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "sxqsfun";
    repo = pname;
    rev = "refs/heads/master";
    sha256 = "1fhw6xspilqn4p2v32q80mrskh0npggrqzdia7s60n85s0v1a3zr";
  };
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
