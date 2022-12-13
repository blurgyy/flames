{ ports }: {
  listen = "127.0.0.1";
  port = ports.tcp;
  protocol = "vmess";
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
}
