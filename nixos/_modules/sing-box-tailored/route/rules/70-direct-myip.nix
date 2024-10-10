{ config }: {
  ip_cidr = [
    { _secret = config.sops.secrets."v2ray/addresses/cn-00".path; }
    { _secret = config.sops.secrets."v2ray/addresses/eu-02".path; }
    { _secret = config.sops.secrets."v2ray/addresses/eu-03".path; }
    { _secret = config.sops.secrets."v2ray/addresses/jp-00".path; }
    { _secret = config.sops.secrets."v2ray/addresses/us-00".path; }
    { _secret = config.sops.secrets."v2ray/addresses/us-01".path; }
    { _secret = config.sops.secrets."v2ray/addresses/us-02".path; }
  ];
  outbound = "direct-private";
}
