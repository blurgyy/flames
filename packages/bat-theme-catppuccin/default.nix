{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dm644 -t $out/share/bat/themes \
      $src/Catppuccin-{frappe,latte,macchiato,mocha}.tmTheme
  '';

  meta = {
    homepage = "https://github.com/catppuccin/bat";
    description = "Soothing pastel theme for Bat";
    license = lib.licenses.mit;
  };
}
