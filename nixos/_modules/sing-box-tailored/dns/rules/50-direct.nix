{
  rule_set = "geosite-cn";
  domain = "@upstream/direct-list:full + upstream/direct-list + custom/30-direct-domain@";
  domain_suffix = "@upstream/direct-list#. + custom/30-direct-domain#.@";
  server = "alidns";
  disable_cache = false;
}
