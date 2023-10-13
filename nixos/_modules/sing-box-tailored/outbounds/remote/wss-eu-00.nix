{ config, secretPath }: {
  type = "vmess";
  # use domain as server for wss outbound
  server._secret = config.sops.secrets."v2ray/domains/wss-eu-00".path;
  server_port = 443;
  uuid._secret = secretPath;
  security = "none";
  tls = {
    enabled = true;
    server_name._secret = config.sops.secrets."v2ray/domains/wss-eu-00".path;
  };
}
