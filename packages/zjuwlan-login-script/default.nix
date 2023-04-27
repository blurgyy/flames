{ stdenvNoCC
, python310

, firefox-bin
, makeWrapper
}: stdenvNoCC.mkDerivation {
  name = "zjuwlan-login-script";
  src = ./zjuwlan.py;

  buildInputs = [
    (python310.withPackages (pp: with pp; [
      selenium
    ]))
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    install -Dvm755 $src $out/bin/zjuwlan
  '';

  # wrap the script with firefox in its PATH
  postFixup = ''
    wrapProgram $out/bin/zjuwlan \
      --prefix PATH : ${firefox-bin}/bin
  '';
}
