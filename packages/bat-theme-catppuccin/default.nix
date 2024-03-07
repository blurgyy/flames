{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dm444 -t $out/share/bat/themes \
      $src/themes/Catppuccin\ {Frappe,Latte,Macchiato,Mocha}.tmTheme
  '';

  meta = {
    homepage = "https://github.com/catppuccin/bat";
    description = "Soothing pastel theme for Bat";
    license = lib.licenses.mit;
  };
}
