{ config, ... }: {
  imports = [
    ./proxy-client-secrets.nix
  ];

  services.sing-box = {
    enable = true;
    preConfigure = true;
    secretPath = config.sops.secrets."v2ray/id".path;
  };
}
