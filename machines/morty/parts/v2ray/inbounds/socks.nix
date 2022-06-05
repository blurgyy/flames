{ config }: {
  listen = "0.0.0.0";
  port = config.sops.placeholder."v2ray/ports/socks";
  protocol = "socks";
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
  settings.auth = "noauth";
}
