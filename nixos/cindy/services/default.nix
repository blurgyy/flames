{ config, ... }: {
  imports = [
    ./hydra.nix
    ./vaultwarden
    ./wakapi.nix
    ./webdav.nix
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
        { name = "cache"; condition = "if is_cache"; }
        { name = "webdav"; condition = "if is_webdav"; }
        { name = "wakapi"; condition = "if is_wakapi"; }
      ];
    };
  };
}
