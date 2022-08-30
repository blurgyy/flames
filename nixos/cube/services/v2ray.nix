{ config, ... }: {
  sops.secrets = {
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
  services.v2ray-tailored.server = (import ../../_parts/v2ray.nix { inherit config; }).server;
  services.haproxy-tailored.backends.v2ray = {
    mode = "tcp";
    server.address = "127.0.0.1:${toString config.services.v2ray-tailored.server.ports.tcp}";
  };
}
