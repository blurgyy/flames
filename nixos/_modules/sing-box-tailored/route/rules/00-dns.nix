{
  type = "logical";
  mode = "or";
  rules = [
    { protocol = "dns"; }
    { port = 53; }
  ];
  outbound = "dns-out";
}
