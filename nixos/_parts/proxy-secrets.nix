let

  domains = [
    "v2ray/domains/eu-02"
    "v2ray/domains/eu-03"
    "v2ray/domains/jp-00"
    "v2ray/domains/us-00"
    "v2ray/domains/us-01"
    "v2ray/domains/us-02"
  ];
  addresses = [
    "v2ray/addresses/cn-00"
    "v2ray/addresses/eu-02"
    "v2ray/addresses/eu-03"
    "v2ray/addresses/jp-00"
    "v2ray/addresses/us-00"
    "v2ray/addresses/us-01"
    "v2ray/addresses/us-02"
    "v2ray/domains/wss-eu-02"
    "v2ray/domains/wss-eu-03"
    "v2ray/domains/wss-jp-00"
    "v2ray/domains/wss-us-00"
    "v2ray/domains/wss-us-01"
    "v2ray/domains/wss-us-02"
  ];
  ports = [
    "v2ray/ports/client/http"
    "v2ray/ports/client/socks"
    "v2ray/ports/client/tproxy"
  ];
  misc = [
    "v2ray/observatory-probe-url"
    "v2ray/ws-path"
    "v2ray/id"
  ];
  server = [
    "v2ray/ports/server/http"
    "v2ray/ports/server/socks"
    "v2ray/ports/server/api"
    "v2ray/ports/server/tcp"
    "v2ray/ports/server/wss"
    "v2ray/ws-path"

    "v2ray/users/00/uuid" "v2ray/users/00-01/uuid" "v2ray/users/00-02/uuid" "v2ray/users/00-03/uuid"
    "v2ray/users/01/uuid" "v2ray/users/01-01/uuid" "v2ray/users/01-02/uuid" "v2ray/users/01-03/uuid"
    "v2ray/users/02/uuid"
    "v2ray/users/03/uuid"
    "v2ray/users/04/uuid"
    "v2ray/users/05/uuid"
    "v2ray/users/06/uuid"
    "v2ray/users/07/uuid"
    "v2ray/users/08/uuid"
    "v2ray/users/09/uuid"

    "v2ray/users/00/email" "v2ray/users/00-01/email" "v2ray/users/00-02/email" "v2ray/users/00-03/email"
    "v2ray/users/01/email" "v2ray/users/01-01/email" "v2ray/users/01-02/email" "v2ray/users/01-03/email"
    "v2ray/users/02/email"
    "v2ray/users/03/email"
    "v2ray/users/04/email"
    "v2ray/users/05/email"
    "v2ray/users/06/email"
    "v2ray/users/07/email"
    "v2ray/users/08/email"
    "v2ray/users/09/email"
  ];

  client = domains ++ addresses ++ misc ++ ports;

  mkSopsSecrets = listOfSecretNames: builtins.listToAttrs (map
    (secret: {
      name = secret;
      value = { sopsFile = ../_secrets.yaml; };
    })
    listOfSecretNames
  );

in

{
  domains = mkSopsSecrets domains;
  addresses = mkSopsSecrets addresses;
  ports = mkSopsSecrets ports;
  misc = mkSopsSecrets misc;

  client = mkSopsSecrets client;
  server = mkSopsSecrets server;
}
