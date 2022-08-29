{ config, ... }: {
  imports = [
    ./hydra.nix
    ./vaultwarden
  ];
  sops.secrets.acme-credentials-file = { owner = config.users.users.haproxy.name; };
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front = {
      domain = {
        acme = {
          enable = true;
          email = "gy@blurgy.xyz";
          credentialsFile = config.sops.secrets.acme-credentials-file.path;
        };
      };
      backends = [
        { name = "vaultwarden"; isDefault = true; condition = "if is_vaultwarden"; }
        { name = "hydra"; condition = "if is_hydra"; }
      ];
    };
  };
}
