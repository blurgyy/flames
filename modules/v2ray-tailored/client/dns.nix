{ extraHosts }: {
  hosts = {
    "dns.google" = [ "8.8.4.4" "8.8.8.8" ];
    "dns.alidns.com" = [ "223.6.6.6" "223.5.5.5" ];
    "dns.rubyfish.cn" = "212.129.148.151";
  } // extraHosts;
  servers = [
    {
      address = "100.100.100.100";  # MagicDNS of tailscale, setup tailscale with `tailscale up --accept-dns=false`
      domains = [ "domain:ts.net" ];
      skipFallback = true;
    }
    {
      address = "10.10.0.21";
      port = 53;
      domains = [ "cc98" "nexushd" "domain:zju.edu.cn" ];
      skipFallback = true;
    }
    {
      address = "https://dns.alidns.com/dns-query";
      domains = [ "domain:ntp.org" ];
      skipFallback = true;
    }
    {
      address = "https://dns.alidns.com/dns-query";
      domains = [ "geosite:cn" ];
      expectIPs = [ "geoip:cn" ];
      skipFallback = true;
    }
    {
      address = "https://dns.google/dns-query";
      domains = [ "geosite:geolocation-!cn" ];
      expectIPs = [ "geoip:!cn" ];
      skipFallback = false;
    }
    "https://1.0.0.1/dns-query"
    "https://8.8.8.8/dns-query"
  ];
  disableCache = false;
  queryStrategy = "UseIPv4";
}
