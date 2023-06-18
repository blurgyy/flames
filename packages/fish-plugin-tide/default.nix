{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;
  buildCommand = ''
    install -Dvm444 -t $out/share/fish/completions $src/completions/*
    install -Dvm444 -t $out/share/fish/conf.d $src/conf.d/*
    cp -r $src/functions $out/share/fish
  '';
  meta = {
    homepage = "https://github.com/IlanCosman/tide";
    description = "The ultimate Fish prompt";
    license = lib.licenses.mit;
  };
}
