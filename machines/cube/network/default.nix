{ config, lib, ... }: let
  domainName = config.networking.fqdn;
in {
  imports = [ ./v2ray.nix ];
  sops.secrets.acme-credentials-file = { owner = config.users.users.haproxy.name; };
  services = {
    haproxy-tailored = {
      enable = true;
      frontends.tls-offload-front = {
        domain.acme = {
          enable = true;
          email = "gy@blurgy.xyz";
          credentialsFile = config.sops.secrets.acme-credentials-file.path;
        };
        backends = [
          { name = "web"; condition = "if HTTP"; }
          { name = "pivot"; condition = "if !HTTP"; }
        ];
      };
      backends = {
        web = { mode = "http"; server.address = "127.0.0.1:8080"; };
        pivot = { mode = "tcp"; server.address = "127.0.0.1:65092"; };
      };
    };
  };
}
