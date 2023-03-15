{ dnsmasq-china-list }: dnsmasq-china-list.overrideAttrs (o: {
  pname = o.pname + "-domains-only";
  buildCommand = ''
    original_dir="${dnsmasq-china-list}/share/dnsmasq-china-list"
    out_dir="$out/share/dnsmasq-china-list-domains-only"
    mkdir -p "$out_dir"

    for section in {accelerated-domains,apple,google}; do
      sed -Ee 's#^server=/(.*?)/.*$#\1#' "$original_dir/$section.china.conf" >"$out_dir/$section.txt"
    done
  '';
})
