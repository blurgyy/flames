{ config, ... }: {
  sops.secrets = {
    "v2ray/users/reverse/uuid" = {};
  };
  imports = [
    ../../_parts/vserver.nix
  ];
  services.v2ray-tailored = {
    client.disabledRoutingRules = [
      "20-random-cn-server-domain.nix"
      "20-random-cn-server-ip.nix"
    ];
    server = {
      logging.access = true;
      reverse = {
        counterpartName = "peterpan";
        counterpartAddr = "81.69.28.75";
        position = "internal";
        port = 10024;
        id = config.sops.placeholder."v2ray/users/reverse/uuid";
      };
    };
  };
}
