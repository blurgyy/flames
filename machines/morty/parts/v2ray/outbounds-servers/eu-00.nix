{ config }: {
  protocol = "vmess";
  settings.vnext = [
    {
      address = config.sops.placeholder."server-addresses/eu-00";
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
      serverName = config.sops.placeholder."v2ray/domains/eu-00";
      allowInsecure = false;
      allowInsecureCiphers = false;
    };
  };
}
