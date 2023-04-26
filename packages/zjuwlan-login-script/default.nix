{ stdenvNoCC
, python310

, firefox-unwrapped
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

  # wrap the script with firefox in its PATH
  postFixup = ''
    wrapProgram $out/bin/zjuwlan \
      --prefix PATH : ${firefox-unwrapped}/bin
  '';

  installPhase = ''
    install -Dvm755 $src $out/bin/zjuwlan
  '';
}
