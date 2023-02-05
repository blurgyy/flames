{ source, stdenvNoCC, lib
, yj
, jq
}: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [ yj jq ];

  buildCommand = ''
    mkdir -p $out/share/alacritty/themes
    for th in $src/catppuccin-{frappe,latte,macchiato,mocha}.yml; do
      cat $th | yj | jq -c .colors >$out/share/alacritty/themes/$(basename -s .yml $th).json
    done
  '';

  meta = {
    homepage = "https://github.com/catppuccin/alacritty";
    description = "Soothing pastel theme for Alacritty";
    license = lib.licenses.mit;
  };
}
