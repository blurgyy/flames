{ generated, writeShellScript, stdenvNoCC
, gnused
, python3
}:

let
  rulesSrc = generated.v2ray-rules-dat.src;
  clashRulesBuildScript = import ./builders/clash.nix { inherit writeShellScript rulesSrc; };
  pwp = python3.withPackages (pp: with pp; [
    fastapi
    uvicorn
  ]);
in

stdenvNoCC.mkDerivation {
  pname = "proxy-rules";
  version = generated.v2ray-rules-dat.version;

  buildInputs = [
    gnused
    pwp
  ];

  buildCommand = ''
    out=$TMPDIR/clash.yaml ${clashRulesBuildScript}
    install -Dvm444 $TMPDIR/clash.yaml $out/clash/generated.yaml

    install -Dvm555 ${./src/clash-rules.py} $out/bin/clash-rules
    install -Dvm555 ${./src/sing-box-rules.py} $out/bin/sing-box-rules
    patchShebangs --build $out/bin/*

    install -Dvm644 -t $out/src/custom ${./custom-rules}/*.txt
    install -Dvm644 -t $out/src/upstream ${rulesSrc}/*.txt
  '';
}
