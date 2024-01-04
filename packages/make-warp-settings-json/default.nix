{ stdenvNoCC
, python3
, cloudflare-warp
}:

stdenvNoCC.mkDerivation {
  pname = "make-warp-settings-json";
  version = "warp${cloudflare-warp.version}";
  src = ./main.py;

  buildInputs = [
    (python3.withPackages (pp: with pp; [
      icmplib
    ]))
  ];

  buildCommand = ''
    install -Dm555 $src $out/bin/make-warp-settings-json
    patchShebangs --build $out/bin/make-warp-settings-json
  '';

  shellHook = ''
    [[ "$-" == *i* ]] && exec "$SHELL"
  '';
}
