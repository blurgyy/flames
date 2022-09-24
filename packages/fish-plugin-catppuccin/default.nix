{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;
  phases = [ "installPhase" ];
  installPhase = ''
    install -Dt $out/share/fish/tools/web_config/themes -m644 $src/themes/*
  '';
  meta = {
    homepage = "https://github.com/catppuccin/fish";
    description = "Soothing pastel theme for the Fish Shell";
    license = lib.licenses.mit;
  };
}
