{ config, ... }: {
  sops.secrets = {
    "v2ray/ports/server/http" = {};
    "v2ray/ports/server/socks" = {};
    "v2ray/ports/server/api" = {};
    "v2ray/ports/server/tcp" = {};
    "v2ray/ports/server/wss" = {};
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

  services.v2ray-tailored.server = {
    enable = true;
    ports.http = config.sops.placeholder."v2ray/ports/server/http";
    ports.socks = config.sops.placeholder."v2ray/ports/server/socks";
    ports.api = config.sops.placeholder."v2ray/ports/server/api";
    ports.tcp = config.sops.placeholder."v2ray/ports/server/tcp";
    ports.wss = config.sops.placeholder."v2ray/ports/server/wss";
    wsPath = config.sops.placeholder."v2ray/ws-path";
    logging.access = true;
    usersInfo = let
      level = 1;
    in [
      {
        uuid = config.sops.placeholder."v2ray/users/00/uuid";
        email = config.sops.placeholder."v2ray/users/00/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/01/uuid";
        email = config.sops.placeholder."v2ray/users/01/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/02/uuid";
        email = config.sops.placeholder."v2ray/users/02/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/03/uuid";
        email = config.sops.placeholder."v2ray/users/03/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/04/uuid";
        email = config.sops.placeholder."v2ray/users/04/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/05/uuid";
        email = config.sops.placeholder."v2ray/users/05/email";
        inherit level;
      }
    ];
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [{ name = "pivot"; condition = "unless HTTP"; }];
    backends.pivot = {
      mode = "tcp";
      server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.tcp}";
    };
  };
}
