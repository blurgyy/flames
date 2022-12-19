{ source, stdenv, lib }: stdenv.mkDerivation {
  inherit (source) pname version src;

  dontConfigure = true;
  installPhase = ''
    install -Dvm444 -t $out/lib/geoip geoip/xt_geoip_query
    install -Dvm444 -t $out/lib/geoip geoip/xt_geoip_build
    install -Dvm444 -t $out/lib/geoip geoip/xt_geoip_build_maxmind
  '';

  meta = {
    homepage = "https://www.netfilter.org/projects/xtables-addons/index.html";
    description = ''
      Xtables-addons is the successor to patch-o-matic(-ng). Likewise, it contains extensions that
      were not, or are not yet, accepted in the main kernel/iptables packages.  This package only
      provides the perl scripts.
    '';
    license = lib.licenses.cc-by-40;
  };
}
