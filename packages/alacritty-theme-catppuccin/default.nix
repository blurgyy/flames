{ source, stdenvNoCC, lib }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    mkdir -p $out/share/alacritty/themes
    install -Dm444 -t $out/share/alacritty/themes \
      $src/catppuccin-{frappe,latte,macchiato,mocha}.toml
  '';

  meta = {
    homepage = "https://github.com/catppuccin/alacritty";
    description = "Soothing pastel theme for Alacritty";
    license = lib.licenses.mit;
  };
}
