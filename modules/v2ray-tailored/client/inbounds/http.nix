{ ports }: {
  listen = "0.0.0.0";
  port = ports.http;
  protocol = "http";
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
}
