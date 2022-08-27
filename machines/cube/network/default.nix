{ config, lib, ... }: let
  domainName = config.networking.fqdn;
in {
  sops.secrets = {
    acme-credentials-file = {};
    "v2ray/ports/api" = {};
    "v2ray/ports/tcp" = {};
    "v2ray/ports/wss" = {};
    "v2ray/ws-path" = {};

    "v2ray/users/00/uuid" = {};
    "v2ray/users/01/uuid" = {};
    "v2ray/users/02/uuid" = {};
    "v2ray/users/03/uuid" = {};
    "v2ray/users/04/uuid" = {};
    "v2ray/users/05/uuid" = {};

    "v2ray/users/00/email" = {};
    "v2ray/users/01/email" = {};
    "v2ray/users/02/email" = {};
    "v2ray/users/03/email" = {};
    "v2ray/users/04/email" = {};
    "v2ray/users/05/email" = {};
  };
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
    v2ray-tailored = {
      server = (import ../../_parts/v2ray.nix { inherit config; }).server;
    };
  };
}
