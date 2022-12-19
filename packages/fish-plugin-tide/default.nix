{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;
  phases = [ "installPhase" ];
  installPhase = ''
    install -Dm644 -t $out/share/fish/completions $src/completions/*
    install -Dm644 -t $out/share/fish/conf.d $src/conf.d/*
    cp -r $src/functions $out/share/fish
  '';
  meta = {
    homepage = "https://github.com/IlanCosman/tide";
    description = "The ultimate Fish prompt";
    license = lib.licenses.mit;
  };
}
