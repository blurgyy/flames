{ ports, wsPath }: {
  listen = "127.0.0.1";
  port = ports.wss;
  protocol = "vmess";
  sniffing = {
    enabled = true;
    destOverride = [ "http" ];
  };
  streamSettings = {
    network = "ws";
    wsSettings.path = wsPath;
  };
}
