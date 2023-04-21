{ config, ... }: {
  sops.secrets = {
    "v2ray/users/reverse/uuid" = {};
  };
  imports = [
    ../../_parts/vclient.nix
    ../../_parts/vserver.nix
  ];
  services.v2ray-tailored = {
    server = {
      logging.access = true;
      reverse = {
        counterpartName = "copi";
        position = "world";
        port = 10024;
        id = config.sops.placeholder."v2ray/users/reverse/uuid";
        proxiedDomains = [
          "cc98"
          "domain:nexushd"
          "domain:zju.edu.cn"
        ];
        proxiedIPs = [
          "10.10.0.0/22"
          "223.4.64.9/32"
          "10.76.0.0/21"
        ];
      };
    };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [ { name = "v2ray"; condition = "if !HTTP"; } ];
    backends.v2ray = {
      mode = "tcp";
      server.address = "127.0.0.1:${toString config.services.v2ray-tailored.server.ports.tcp}";
    };
  };
}
