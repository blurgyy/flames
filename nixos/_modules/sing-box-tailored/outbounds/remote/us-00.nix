{ config }: {
  type = "vmess";
  server._secret = config.sops.secrets."v2ray/addresses/us-00".path;
  server_port = 443;
  security = "none";
  tls = {
    enabled = true;
    server_name._secret = config.sops.secrets."v2ray/domains/us-00".path;
  };
}
