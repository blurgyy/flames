{ generated, writeShellScript, stdenvNoCC
, gnused
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
  ];

  buildCommand = ''
    out=$TMPDIR/clash.yaml ${clashRulesBuildScript}
    install -Dvm444 $TMPDIR/clash.yaml $out/clash/generated.yaml

    install -Dvm644 -t $out/src/custom ${./custom-rules}/*.txt
    install -Dvm644 -t $out/src/upstream ${rulesSrc}/*.txt
  '';
}
