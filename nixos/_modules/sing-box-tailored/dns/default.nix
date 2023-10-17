{ mapDir, applyTag, call }:

{
  servers = map
    (dnsConfig: dnsConfig // { address_strategy = "prefer_ipv4"; strategy = "ipv4_only"; })
    (mapDir applyTag ./servers);
  rules = mapDir (path: call path {}) ./rules;
  final = "cloudflare-oversea";
  strategy = "";
  disable_cache = false;
  disable_expire = false;
}
