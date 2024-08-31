{ config, ... }: {
  sops.secrets = (import ./proxy-secrets.nix).server;

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
        uuid = config.sops.placeholder."v2ray/users/00-01/uuid";
        email = config.sops.placeholder."v2ray/users/00-01/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/00-02/uuid";
        email = config.sops.placeholder."v2ray/users/00-02/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/00-03/uuid";
        email = config.sops.placeholder."v2ray/users/00-03/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/01/uuid";
        email = config.sops.placeholder."v2ray/users/01/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/01-01/uuid";
        email = config.sops.placeholder."v2ray/users/01-01/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/01-02/uuid";
        email = config.sops.placeholder."v2ray/users/01-02/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/01-03/uuid";
        email = config.sops.placeholder."v2ray/users/01-03/email";
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
      {
        uuid = config.sops.placeholder."v2ray/users/06/uuid";
        email = config.sops.placeholder."v2ray/users/06/email";
        inherit level;
      }
      {
        uuid = config.sops.placeholder."v2ray/users/07/uuid";
        email = config.sops.placeholder."v2ray/users/07/email";
        inherit level;
      }
    ];
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [{
      name = "pivot";
      condition = "unless HTTP";
    }];
    backends.pivot = {
      mode = "tcp";
      server.address = "127.0.0.1:${config.services.v2ray-tailored.server.ports.tcp}";
    };
  };
}
