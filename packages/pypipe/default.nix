{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dvm555 $src/pypipe.py $out/bin/ppp
  '';

  meta = {
    homepage = "pypipe";
    description = "Python pipe command line tool";
    license = lib.licenses.asl20;
  };
}
