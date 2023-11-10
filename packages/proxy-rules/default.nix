{ generated, writeShellScript, stdenvNoCC
, gnused
, python3
, makeWrapper
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
    makeWrapper
  ];

  buildCommand = ''
    out=$TMPDIR/clash.yaml ${clashRulesBuildScript}
    install -Dvm444 $TMPDIR/clash.yaml $out/clash/generated.yaml

    install -Dvm555 ${./src/populate-sing-box-rules.py} $out/bin/populate-sing-box-rules
    wrapProgram $out/bin/populate-sing-box-rules \
      --prefix PATH : ${python3}/bin

    install -Dvm644 -t $out/src/custom ${./custom-rules}/*.txt
    install -Dvm644 -t $out/src/upstream ${rulesSrc}/*.txt
  '';
}
