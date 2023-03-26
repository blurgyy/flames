{ generated, stdenvNoCC
, gnused
}:

let
  rulesSrc = generated.v2ray-rules-dat.src;
in

stdenvNoCC.mkDerivation {
  pname = "clash-rules";
  version = generated.v2ray-rules-dat.version;

  buildInputs = [
    gnused
  ];

  buildCommand = ''
    touch $out

    cat ${custom-rules/zju.rules} \
      | sed 's/^/  - /' >$TMPDIR/zju.rules
    cat ${custom-rules/abroad.rules} \
      | sed 's/^/  - /' >$TMPDIR/abroad.rules

    # Includes custom and external direct rules, and Windows update domains
    cat ${custom-rules/direct.rules} \
      | sed '/^\s*$/d' \
      | sed 's/^/  - /' >$TMPDIR/direct.rules
    cat ${rulesSrc}/direct-tld-list.txt \
      ${rulesSrc}/direct-list.txt \
      ${rulesSrc}/win-update.txt \
        | sed '/^\s*$/d' \
        | sed '/:/d' \
        | sed 's/^/  - DOMAIN-SUFFIX,/' \
        | sed 's/$/,DIRECT/' >>$TMPDIR/direct.rules

    # Includes custom blocking rules, advertisements and Windows telemetry
    cat ${custom-rules/blocked.rules} \
      | sed '/^\s*$/d' \
      | sed 's/^/  - /' >$TMPDIR/blocked.rules
    cat ${rulesSrc}/reject-tld-list.txt \
      ${rulesSrc}/reject-list.txt \
      ${rulesSrc}/win-spy.txt \
        | sed '/^\s*$/d' \
        | sed '/:/d' \
        | sed 's/^/  - DOMAIN-SUFFIX,/' \
        | sed 's/$/,REJECT/' >>$TMPDIR/blocked.rules

    # Strip empty lines
    sed -i '/^\s*$/d' $TMPDIR/*.rules
    # Strip comment lines
    sed -i '/^\s*[#;]/d' $TMPDIR/*.rules
    # Delete non-printable characters
    sed -i 's/[^[:print:]]//g' $TMPDIR/*.rules
    # IP6-CIDR -> IP-CIDR6
    sed -i 's/^IP6-CIDR/IP-CIDR6/g' $TMPDIR/*.rules
    # Delete "USER-AGENT" rules
    sed -i '/^USER-AGENT/d' $TMPDIR/*.rules

    echo -e "\n  # ZJU ----------------------------------------------------------------------" >>$out
    cat $TMPDIR/zju.rules >>$out
    echo -e "\n  # Blocked ------------------------------------------------------------------" >>$out
    cat $TMPDIR/blocked.rules >>$out
    echo -e "\n  # Direct -------------------------------------------------------------------" >>$out
    cat $TMPDIR/direct.rules >>$out
    echo -e "\n  # Abroad -------------------------------------------------------------------" >>$out
    cat $TMPDIR/abroad.rules >>$out
    echo -e "\n  # All other traffic --------------------------------------------------------" >>$out
    echo "  - MATCH,ABROAD" >>$out

  '';
}
