{ generated, writeShellScript, stdenvNoCC
, gnused
, python3
}:

let
  rulesSrc = generated.v2ray-rules-dat.src;
  clashRulesBuildScript = import ./builders/clash.nix { inherit writeShellScript rulesSrc; };
in

stdenvNoCC.mkDerivation {
  pname = "proxy-rules";
  version = generated.v2ray-rules-dat.version;

  buildInputs = [
    gnused
    python3
  ];

  buildCommand = ''
    out=$TMPDIR/clash.yaml ${clashRulesBuildScript}
    install -Dvm444 $TMPDIR/clash.yaml $out/clash/generated.yaml

    install -Dvm555 ${./src/populate-sing-box-rules.py} $out/bin/populate-sing-box-rules
    patchShebangs --build $out/bin/populate-sing-box-rules

    install -Dvm644 -t $out/src/custom ${./custom-rules}/*.txt
    install -Dvm644 -t $out/src/upstream ${rulesSrc}/*.txt
  '';
}
