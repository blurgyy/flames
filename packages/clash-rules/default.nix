{ generated, writeShellScript, stdenvNoCC
, gnused
}:

let
  rulesSrc = generated.v2ray-rules-dat.src;
  clashRulesBuildScript = import ./builders/clash.nix { inherit writeShellScript rulesSrc; };
in

stdenvNoCC.mkDerivation {
  pname = "clash-rules";
  version = generated.v2ray-rules-dat.version;

  buildInputs = [
    gnused
  ];

  buildCommand = ''
    out=$TMPDIR/clash.yaml ${clashRulesBuildScript}
    install -Dvm444 $TMPDIR/clash.yaml $out/clash/generated.yaml
  '';
}
