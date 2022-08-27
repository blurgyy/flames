{ config, pkgs, ... }: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    webVaultPackage = pkgs.vaultwarden-vault;
    config = {
      DATA_FOLDER = "/var/lib/vaultwarden";
      WEB_VAULT_ENABLED = true;
      WEB_VAULT_FOLDER = "${pkgs.vaultwarden-vault}/share/vaultwarden/vault";
      ROCKET_PORT = 62332;
      ROCKET_LIMITS = "{json=10485760}";
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_vaultwarden"; body = "hdr(host) -i vw.${config.networking.domain}"; } ];
      domain.extraNames = [ "vw.${config.networking.domain}" ];
    };
  };
}
