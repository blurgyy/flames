{ stdenvNoCC
, python310

, geckodriver
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

  # needed for substituteAllInPlace to work
  inherit geckodriver;

  installPhase = ''
    install -Dvm555 $src $out/bin/zjuwlan
    substituteAllInPlace $out/bin/zjuwlan
  '';

  # wrap the script with firefox in its PATH
  postFixup = ''
    wrapProgram $out/bin/zjuwlan \
      --prefix PATH : ${firefox-unwrapped}/bin
  '';

  meta.mainProgram = "zjuwlan";
}
