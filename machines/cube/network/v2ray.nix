{ config }: {
  server = {
    enable = true;
    ports.api = config.sops.placeholder."v2ray/ports/api";
    ports.tcp = config.sops.placeholder."v2ray/ports/tcp";
    ports.wss = config.sops.placeholder."v2ray/ports/wss";
    wsPath = config.sops.placeholder."v2ray/ws-path";
    usersInfo = let
      level = 0;
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
