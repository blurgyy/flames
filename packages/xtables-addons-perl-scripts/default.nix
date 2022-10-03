{ source, stdenv, lib }: stdenv.mkDerivation {
  inherit (source) pname version src;

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    install -Dt $out/lib/geoip -m444 geoip/xt_geoip_query
    install -Dt $out/lib/geoip -m444 geoip/xt_geoip_build
    install -Dt $out/lib/geoip -m444 geoip/xt_geoip_build_maxmind
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
