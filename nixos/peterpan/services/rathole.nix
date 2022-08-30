{ config, lib, ... }: let
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
    "rathole/bind-addr" = {};
    "rathole/bind-port" = {};
  } // ratholeServiceTokens // ratholeServiceAddrs // ratholeServicePorts;
  services.rathole = {
    enable = true;
    server = {
      bindAddr = config.sops.placeholder."rathole/bind-addr";
      bindPort = config.sops.placeholder."rathole/bind-port";
      services = with lib; listToAttrs (map (name: nameValuePair name {
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
      ]);
    };
  };
  services.haproxy-tailored.backends.web = {
    mode = "http";
    requestRules = [ "replace-uri /zju(.*)$ \\1" ];
    server.address = "127.0.0.1:${config.services.rathole.server.services.coderp-watson.bindPort}";
  };
}
