{ config, lib, pkgs, ... }: {
  networking.nftables = {
    enable = true;
    ruleset = builtins.readFile ../_parts/raw/nftables-default.conf;
  };
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
      ];
    };
  };
}
