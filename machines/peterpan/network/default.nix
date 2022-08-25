{ config, ... }: let
  ratholeServiceNames = [
    "ssh-morty"
    "ssh-rpi"
    "ssh-watson"
    "ssh-lab-2x1080ti"
    "ssh-lab-shared"
    "coderp-watson"
    "acremote-rpi"
  ];
  ratholeServiceTokens = (builtins.listToAttrs (map (name: {
    name = "rathole/${name}/token";
    value = {};
  }) ratholeServiceNames));
  ratholeServiceAddrs = (builtins.listToAttrs (map (name: {
    name = "rathole/${name}/addr";
    value = {};
  }) ratholeServiceNames));
in {
  networking.nftables = {
    enable = true;
    ruleset = builtins.readFile ../../_parts/raw/nftables-default.conf;
  };
  sops.secrets = {
    "v2ray/id" = {};
    "v2ray/observatory-probe-url" = {};
    "v2ray/ws-path" = {};

    "v2ray/ports/http" = {};
    "v2ray/ports/socks" = {};
    "v2ray/ports/tproxy" = {};

    "v2ray/ports/api" = {};
    "v2ray/ports/tcp" = {};
    "v2ray/ports/wss" = {};

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

    "v2ray/ports/reverse" = {};
    "v2ray/users/reverse/uuid" = {};
    "v2ray/users/reverse/email" = {};

    "v2ray/addresses/us-00" = {};
    "v2ray/addresses/hk-00" = {};
    "v2ray/addresses/eu-00" = {};
    "v2ray/addresses/cn-00" = {};

    "v2ray/domains/us-00" = {};
    "v2ray/domains/hk-00" = {};
    "v2ray/domains/eu-00" = {};
    "v2ray/domains/wss-us-00" = {};
    "v2ray/domains/wss-eu-00" = {};

    "rathole/bind-addr" = {};
  } // ratholeServiceTokens // ratholeServiceAddrs;
  services = {
    haproxy-tailored = import ./haproxy.nix { inherit config; };
    rathole = {
      enable = true;
      server = {
        bindAddr = config.sops.placeholder."rathole/bind-addr";
        services = map (name: {
          inherit name;
          token = config.sops.placeholder."rathole/${name}/token";
          bindAddr = config.sops.placeholder."rathole/${name}/addr";
        }) [
          "ssh-morty"
          "ssh-rpi"
          "ssh-watson"
          "ssh-lab-2x1080ti"
          "ssh-lab-shared"
          "coderp-watson"
          "acremote-rpi"
        ];
      };
    };
    v2ray-tailored = {
      client = (import ../../_parts/v2ray.nix { inherit config; }).client;
      server = (import ../../_parts/v2ray.nix { inherit config; }).server // {
        reverse = {
          counterpartName = "watson";
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
  };
}
