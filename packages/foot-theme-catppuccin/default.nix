{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dm444 -t $out/share/foot/themes \
      $src/catppuccin-{frappe,latte,macchiato,mocha}.ini
  '';

  meta = {
    homepage = "https://github.com/catppuccin/foot";
    description = "Soothing pastel theme for Foot";
    license = lib.licenses.mit;
  };
}
