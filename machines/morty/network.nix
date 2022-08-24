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
    configFile = config.sops.templates.rathole-config.path;
  };

  sops.templates.rathole-config.content = pkgs.toTOML (import ./parts/rathole.nix { inherit config; });
}
