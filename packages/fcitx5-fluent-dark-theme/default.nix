{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm644 -t $out/share/fcitx5/themes/FluentDark $src/FluentDark/*
  '';

  meta = {
    homepage = "https://github.com/Reverier-Xu/FluentDark-fcitx5";
    description = "A Fluent-Design dark theme with blur effect and shadow";
    license = lib.licenses.unfreeRedistributable;
  };
}
