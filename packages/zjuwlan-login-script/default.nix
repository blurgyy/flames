{ python310, stdenvNoCC }: stdenvNoCC.mkDerivation {
  name = "zjuwlan-login-script";
  src = ./zjuwlan.py;

  buildInputs = [
    (python310.withPackages (pp: with pp; [
      selenium
    ]))
  ];

  dontUnpack = true;
  installPhase = ''
    install -Dvm755 $src $out/bin/zjuwlan
  '';
}
