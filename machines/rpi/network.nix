{ config, lib, pkgs, ... }: let
  rathole-config-content = pkgs.toTOML {
    client.remote_addr = config.sops.placeholder."rathole/remote_addr";
    client.services = {
      "ssh-${config.networking.hostName}" = {
        token = config.sops.placeholder."rathole/ssh/token";
        local_addr = "127.1:22";
      };
      "acremote-${config.networking.hostName}" = {
        token = config.sops.placeholder."rathole/acremote/token";
        local_addr = "127.1:12682";
      };
    };
  };
in {
  services.v2ray-tailored = {
    client = (import ../_parts/v2ray.nix { inherit config; }).client;
  };
  services.rathole = {
    enable = true;
    client = {
      remoteAddr = config.sops.placeholder."rathole/remote_addr";
      services = [
        {
          name = "ssh-${config.networking.hostName}";
          token = config.sops.placeholder."rathole/ssh/token";
          localAddr = "127.1:22";
        }
        {
          name = "acremote-${config.networking.hostName}";
          token = config.sops.placeholder."rathole/acremote/token";
          localAddr = "127.1:12682";
        }
      ];
    };
  };
}
