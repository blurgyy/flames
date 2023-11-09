{ stdenvNoCC
, python3
}:

stdenvNoCC.mkDerivation {
  name = "get-xkb-symbols";

  buildInputs = [
    python3
  ];

  buildCommand = ''
    install -Dvm555 ${./main.py} $out
    patchShebangs --build $out
  '';
}
