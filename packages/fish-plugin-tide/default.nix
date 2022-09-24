{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;
  phases = [ "installPhase" ];
  installPhase = ''
    set -x
    mkdir -p $out/share/fish/{conf.d,completions,functions}
    cp -r $src/completions/* $out/share/fish/completions
    cp -r $src/conf.d/* $out/share/fish/conf.d
    cp -r $src/functions/* $out/share/fish/functions
  '';
  meta = {
    homepage = "https://github.com/IlanCosman/tide";
    description = "The ultimate Fish prompt";
    license = lib.licenses.mit;
  };
}
