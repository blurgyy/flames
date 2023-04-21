{ stdenvNoCC
, python310
, firefox-unwrapped
}: stdenvNoCC.mkDerivation {
  name = "zjuwlan-login-script";
  src = ./zjuwlan.py;

  buildInputs = [
    (python310.withPackages (pp: with pp; [
      selenium
      firefox-unwrapped
    ]))
  ];

  dontUnpack = true;
  installPhase = ''
    install -Dvm755 $src $out/bin/zjuwlan
  '';
}
