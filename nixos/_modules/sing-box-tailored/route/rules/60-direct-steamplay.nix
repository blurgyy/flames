{
  type = "logical";
  mode = "or";
  rules = [{
    network = "tcp";
    port_range = "27015:27030";
  } {
    network = "udp";
    port = [
      3478
      4379
      4380
    ];
    port_range = "27000:27100";
  }];
  outbound = "direct-steamplay";
}
