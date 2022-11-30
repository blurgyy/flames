{ config, ... }: {
  sops.secrets = {
    "v2ray/ports/http" = {};
    "v2ray/ports/socks" = {};
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
  services.v2ray-tailored.server = {
    enable = true;
    ports.http = config.sops.placeholder."v2ray/ports/http";
    ports.socks = config.sops.placeholder."v2ray/ports/socks";
    ports.api = config.sops.placeholder."v2ray/ports/api";
    ports.tcp = config.sops.placeholder."v2ray/ports/tcp";
    ports.wss = config.sops.placeholder."v2ray/ports/wss";
    wsPath = config.sops.placeholder."v2ray/ws-path";
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
}
