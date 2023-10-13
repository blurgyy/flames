{ config, secretPath }: {
  type = "vmess";
  server._secret = config.sops.secrets."v2ray/addresses/eu-01".path;
  server_port = 443;
  uuid._secret = secretPath;
  security = "none";
  tls = {
    enabled = true;
    server_name._secret = config.sops.secrets."v2ray/domains/eu-01".path;
  };
}
