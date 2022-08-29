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
}
