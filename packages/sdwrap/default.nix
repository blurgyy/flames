{ stdenv }:
stdenv.mkDerivation {
  pname = "sdwrap";
  version = "0.0.0";
  src = ./src;
  phases = [ "installPhase" ];

  installPhase = ''
    install -Dt $out/bin -m555 $src/*
    for script in $out/bin/*; do
      substituteAllInPlace $script
    done
  '';
}
