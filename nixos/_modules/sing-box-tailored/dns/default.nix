{ mapDir, applyTagWithOverrides }:

{
  servers = map
    (dnsConfig: dnsConfig // { address_strategy = "prefer_ipv4"; strategy = "ipv4_only"; })
    (mapDir (applyTagWithOverrides {}) ./servers);
  rules = mapDir import ./rules;
  final = "cloudflare-oversea";
  strategy = "";
  disable_cache = false;
  disable_expire = false;
}
