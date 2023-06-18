{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;
  buildCommand = ''
    install -Dvm444 -t $out/share/fish/tools/web_config/themes $src/themes/*
  '';
  meta = {
    homepage = "https://github.com/catppuccin/fish";
    description = "Soothing pastel theme for the Fish Shell";
    license = lib.licenses.mit;
  };
}
