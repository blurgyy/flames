{ config, ... }: {
  sops.secrets = (import ./proxy-secrets.nix).client;

  services.sing-box = {
    enable = true;
    preConfigure = true;
    secretPath = config.sops.secrets."v2ray/id".path;
  };
}
