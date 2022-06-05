{ config }: {
  protocol = "vmess";
  settings.vnext = [
    {
      address = config.sops.placeholder."v2ray/domains/wss-eu-00";
      port = 443;
      users = [
        {
          id = config.sops.placeholder."v2ray/users/a/id";
          security = "none";
          alterId = 0;
        }
      ];
    }
  ];
  streamSettings = {
    network = "ws";
    security = "tls";
    tlsSettings = {
      serverName = config.sops.placeholder."v2ray/domains/wss-eu-00";
      allowInsecure = false;
      allowInsecureCiphers = false;
    };
    wsSettings.path = config.sops.placeholder."v2ray/ws-path";
  };
}
