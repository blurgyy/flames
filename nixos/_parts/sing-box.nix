{ config, ... }: {
  sops.secrets = builtins.listToAttrs (map
    (secret: {
      name = secret;
      value = {};
    })
    (import ./proxy-client-secrets.nix).default
  );

  services.sing-box = {
    enable = true;
    preConfigure = true;
    secretPath = config.sops.secrets."v2ray/id".path;
  };
}
