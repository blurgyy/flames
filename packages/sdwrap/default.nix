{ stdenv
, bash }: stdenv.mkDerivation {
  name = "sdwrap";
  src = ./src;
  phases = [ "installPhase" ];

  inherit bash;

  installPhase = ''
    install -Dt $out/bin -m555 $src/*
    for script in $out/bin/*; do
      substituteAllInPlace $script
    done
  '';
}
