{ writeShellScript, rulesSrc }:

writeShellScript "build-clash-rules" ''
  # Includes custom blocking rules, advertisements and Windows telemetry
  cat ${../custom-rules/00-blocked.txt} \
    | sed '/^\s*$/d' \
    | sed '/:/d' \
    | sed 's/^/  - DOMAIN-SUFFIX,/' \
    | sed 's/$/,REJECT/' >>$TMPDIR/blocked.rules
  cat ${rulesSrc}/reject-tld-list.txt \
    ${rulesSrc}/reject-list.txt \
    ${rulesSrc}/win-spy.txt \
      | sed '/^\s*$/d' \
      | sed '/:/d' \
      | sed 's/^/  - DOMAIN-SUFFIX,/' \
      | sed 's/$/,REJECT/' >>$TMPDIR/blocked.rules

  # zju
  cat ${../custom-rules/10-zju-direct-domain-suffix.txt} \
    | sed '/^\s*$/d' \
    | sed '/:/d' \
    | sed 's/^/  - DOMAIN-SUFFIX,/' \
    | sed 's/$/,DIRECT/' >>$TMPDIR/zju.rules
  cat ${../custom-rules/20-zju-domain-keyword.txt} \
    | sed '/^\s*$/d' \
    | sed '/:/d' \
    | sed 's/^/  - DOMAIN-KEYWORD,/' \
    | sed 's/$/,ZJU/' >>$TMPDIR/zju.rules
  cat ${../custom-rules/20-zju-domain-suffix.txt} \
    | sed '/^\s*$/d' \
    | sed '/:/d' \
    | sed 's/^/  - DOMAIN-SUFFIX,/' \
    | sed 's/$/,ZJU/' >>$TMPDIR/zju.rules
  cat ${../custom-rules/20-zju-ip.txt} \
    | sed '/^\s*$/d' \
    | sed '/:/d' \
    | sed 's/^/  - IP-CIDR,/' \
    | sed 's/$/,ZJU/' >>$TMPDIR/zju.rules

  # Includes custom and external direct rules, and Windows update domains
  echo "  - GEOIP,CN,DIRECT,no-resolve" >$TMPDIR/direct.rules
  echo "  - GEOIP,PRIVATE,DIRECT,no-resolve" >>$TMPDIR/direct.rules
  cat ${../custom-rules/30-direct.txt} \
    ${rulesSrc}/direct-tld-list.txt \
    ${rulesSrc}/direct-list.txt \
    ${rulesSrc}/win-update.txt \
      | sed '/^\s*$/d' \
      | sed '/:/d' \
      | sed 's/^/  - DOMAIN-SUFFIX,/' \
      | sed 's/$/,DIRECT/' >>$TMPDIR/direct.rules

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

  # write outputs
  touch $out

  echo -e "\n  # Blocked ------------------------------------------------------------------" >>$out
  cat $TMPDIR/blocked.rules >>$out
  echo -e "\n  # ZJU ----------------------------------------------------------------------" >>$out
  cat $TMPDIR/zju.rules >>$out
  echo -e "\n  # Direct -------------------------------------------------------------------" >>$out
  cat $TMPDIR/direct.rules >>$out
  echo -e "\n  # All other traffic --------------------------------------------------------" >>$out
  echo "  - MATCH,ABROAD" >>$out
''
