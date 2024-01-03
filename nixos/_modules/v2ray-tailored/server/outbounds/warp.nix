{ config }: {
  protocol = "socks";
  settings.servers = [{
    address = "127.0.0.1";
    port = config.services.warp-proxy.port;
  }];
}
