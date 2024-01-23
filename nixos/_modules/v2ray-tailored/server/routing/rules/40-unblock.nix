{ config }: {
  domain = [
    "domain:reddit.com"
    "domain:redd.it"
    "domain:cloudflare.com"
    "domain:cloudflare.net"
    "domain:cloudflare-dns.com"
  ];
  ip_cidr = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  outboundTag = if config.services.warp-proxy.enable
    then "warp:unblock"
    else "direct:unblock";
}
