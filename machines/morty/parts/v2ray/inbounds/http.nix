{ config }: {
  listen = "0.0.0.0";
  port = config.sops.placeholder."v2ray/ports/http";
  protocol = "http";
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
}
