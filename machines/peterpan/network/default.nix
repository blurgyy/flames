{ config, lib, ... }: let
  domainName = config.networking.fqdn;
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
  ratholeServicePorts = (builtins.listToAttrs (map (name: {
    name = "rathole/${name}/port";
    value = {};
  }) ratholeServiceNames));
in {
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
    "rathole/bind-port" = {};
  } // ratholeServiceTokens // ratholeServiceAddrs // ratholeServicePorts;
  services = {
    haproxy-tailored = {
      enable = true;
      frontends.tls-offload-front = {
        domain.acme.enable = false;
        backends = [
          { name = "web"; condition = "if HTTP"; }
          { name = "pivot"; condition = "if !HTTP"; }
        ];
      };
      backends = {
        web = { mode = "http"; server.address = "127.0.0.1:8080"; };
        pivot = { mode = "tcp"; server.address = "127.0.0.1:65092"; };
      };
    };
    rathole = {
      enable = true;
      server = {
        bindAddr = config.sops.placeholder."rathole/bind-addr";
        bindPort = config.sops.placeholder."rathole/bind-port";
        services = map (name: {
          inherit name;
          token = config.sops.placeholder."rathole/${name}/token";
          bindAddr = config.sops.placeholder."rathole/${name}/addr";
          bindPort = config.sops.placeholder."rathole/${name}/port";
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
    soft-serve = {
      enable = true;
      bind.addr = "0.0.0.0";
      bind.port = 77;
      display.name = "Git Server TUI (hosted with soft-serve on ${config.networking.hostName})";
      display.host = "${config.networking.fqdn}";
      #keyFile
      #repoDirectory
      anonAccess = "no-access";
      allowKeyless = true;
      users.gy = {
        isAdmin = true;
        publicKeys = config.users.users.gy.openssh.authorizedKeys.keys;
        collabRepos = [];
      };
    };
  };
  networking.firewall-tailored.acceptedPorts = [{
    port = config.services.soft-serve.bind.port;
    protocols = [ "tcp" ];
    comment = "Allow traffic on soft-serve's hosting port";
  }];
}
