{ pkgs }: {
  verbosity = "warn";
  address = "127.0.0.53:53";
  script = import ./flow.rn.nix { inherit pkgs; };
  upstreams = let
    mkUdp =
      { host, port ? 53 }: { udp.addr = "${host}:${toString port}"; };
    mkDoh =
      { domain, IP, queryPath ? "/dns-query", rateLimit ? null }: {
          https = {
            uri = "https://${domain}${queryPath}";
            ratelimit = rateLimit;
            addr = IP;
          };
        };
  in {
    # UDP
    tailscale = mkUdp { host = "100.100.100.100"; };
    zju = mkUdp { host = "10.10.0.21"; };
    ntp = mkUdp { host = "8.8.8.8"; };

    # DoH
    alidns = mkDoh { domain = "dns.alidns.com"; IP = "223.6.6.6"; };
    "1001" = mkDoh { domain = "cloudflare-dns.com"; IP = "1.0.0.1"; };
    "1111" = mkDoh { domain = "cloudflare-dns.com"; IP = "1.1.1.1"; };
    "1002" = mkDoh { domain = "cloudflare-dns.com"; IP = "1.0.0.2"; };
    "1112" = mkDoh { domain = "cloudflare-dns.com"; IP = "1.1.1.2"; };
    "8844" = mkDoh { domain = "dns.google"; IP = "8.8.4.4"; };
    "8888" = mkDoh { domain = "dns.google"; IP = "8.8.8.8"; };

    # cf, google
    cloudflare.hybrid = [ "1001" "1111" ];
    cloudflare-filtered.hybrid = [ "1002" "1112" ];
    google.hybrid = [ "8844" "8888" ];

    # interfaces
    domestic
      .hybrid = [ "alidns" ];
    oversea
      .hybrid = [ "cloudflare" "google" ];
    oversea-filtered
      .hybrid = [ "cloudflare-filtered" ];
  };
}
