{ ports }: {
  listen = "0.0.0.0";
  port = ports.socks;
  protocol = "socks";
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
  settings.auth = "noauth";
}
