{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;
  phases = [ "installPhase" ];
  installPhase = ''
    set -x
    mkdir -p $out/share/fish/vendor_{conf,completions,functions}.d
    cp -r $src/completions/* $out/share/fish/vendor_completions.d
    cp -r $src/conf.d/* $out/share/fish/vendor_conf.d
    cp -r $src/functions/* $out/share/fish/vendor_functions.d
  '';
  meta = {
    homepage = "https://github.com/IlanCosman/tide";
    description = "The ultimate Fish prompt";
    license = lib.licenses.mit;
  };
}
