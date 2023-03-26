{ stdenvNoCC
, coreutils
, gnugrep
, gnused
, util-linux
}: stdenvNoCC.mkDerivation {
  name = "rules-serve-cgi";
  buildInputs = [
    coreutils
    util-linux
    gnused
  ];

  cat="${coreutils}/bin/cat";
  cut="${coreutils}/bin/cut";
  grep="${gnugrep}/bin/grep";
  sed="${gnused}/bin/sed";
  uuidgen="${util-linux}/bin/uuidgen";

  buildCommand = ''
    mkdir -p $out/bin
    install -Dvm755 ${./clash} $out/bin/clash
    substituteAllInPlace $out/bin/clash
  '';
}
