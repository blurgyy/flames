{ config }: {
  protocol = "vmess";
  settings.vnext = [
    {
      address = config.sops.placeholder."server-addresses/cn-00";
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
      allowInsecure = true;
      allowInsecureCiphers = false;
    };
  };
}
