{ source, lib, stdenvNoCC }: stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildCommand = ''
    install -Dm644 -t $out/share/dnsmasq-china-list \
      $src/{accelerated-domains,apple,bogus-nxdomain,google}.china.conf
  '';

  meta = {
    homepage = "https://github.com/felixonmars/dnsmasq-china-list";
    description = "Chinese-specific configuration to improve your favorite DNS server. Best partner for chnroutes.";
    license = lib.licenses.wtfpl;
  };
}
