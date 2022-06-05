{ config }: {
  protocol = "vmess";
  settings.vnext = [
    {
      address = config.sops.placeholder."server-addresses/us-00";
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
    network = "tcp";
    security = "tls";
    tlsSettings = {
      serverName = config.sops.placeholder."v2ray/domains/us-00";
      allowInsecure = false;
      allowInsecureCiphers = false;
    };
  };
}
