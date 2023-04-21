{ config, ... }: {
  sops.secrets = {
    "v2ray/ports/server/reverse" = {};
    "v2ray/users/reverse/uuid" = {};
  };
  imports = [
    ../../_parts/vclient.nix
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
        port = config.sops.placeholder."v2ray/ports/server/reverse";
        id = config.sops.placeholder."v2ray/users/reverse/uuid";
      };
    };
  };
}
