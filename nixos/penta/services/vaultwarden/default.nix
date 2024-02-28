{ config, pkgs, ... }: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    webVaultPackage = pkgs.vaultwarden-vault;
    config = {
      signupsAllowed = false;
      webVaultEnabled = true;
      webVaultFolder = "${pkgs.vaultwarden-vault}/share/vaultwarden/vault";
      rocketPort = 62332;
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_vaultwarden"; body = "hdr(host) -i vw.${config.networking.domain}"; } ];
      domain.extraNames = [ "vw.${config.networking.domain}" ];
      backends = [ { name = "vaultwarden"; isDefault = false; condition = "if is_vaultwarden"; } ];
    };
    backends.vaultwarden = {
      mode = "http";
      server.address = "127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}";
    };
  };
}
