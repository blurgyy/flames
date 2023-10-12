{ config }: {
  type = "vmess";
  server._secret = config.sops.secrets."v2ray/addresses/eu-00".path;
  server_port = 443;
  uuid._secret = config.sops.secrets."v2ray/id".path;
  security = "none";
  tls = {
    enabled = true;
    server_name._secret = config.sops.secrets."v2ray/domains/eu-00".path;
  };
}
