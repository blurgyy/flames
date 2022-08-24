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
  networking.nftables.ruleset = builtins.readFile ../_parts/raw/nftables-default.conf;
  services.v2ray-tailored = {
    client = (import ../_parts/v2ray.nix { inherit config; }).client;
  };
  services.rathole = {
    enable = true;
    configFile = config.sops.templates.rathole-config.path;
  };
  sops.templates.rathole-config.content = rathole-config-content;
}
