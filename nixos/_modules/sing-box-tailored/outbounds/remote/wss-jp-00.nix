{ config }: {
  type = "vmess";
  # use domain as server for wss outbound
  server._secret = config.sops.secrets."v2ray/domains/wss-jp-00".path;
  server_port = 443;
  security = "none";
  tls = {
    enabled = true;
    server_name._secret = config.sops.secrets."v2ray/domains/wss-jp-00".path;
  };
  transport = {
    type = "ws";
    path._secret = config.sops.secrets."v2ray/ws-path".path;
  };
}
