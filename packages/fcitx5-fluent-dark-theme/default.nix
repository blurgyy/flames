{ source, lib, stdenv }: stdenv.mkDerivation rec {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    install -dm755 $out/share/fcitx5/themes
    cp -rv $src/FluentDark $out/share/fcitx5/themes
  '';

  meta = {
    homepage = "https://github.com/Reverier-Xu/FluentDark-fcitx5";
    description = "A Fluent-Design dark theme with blur effect and shadow";
    license = lib.licenses.unfree;
  };
}
