{ config, ... }: {
  networking.nftables = {
    enable = true;
    ruleset = builtins.readFile ../../_parts/raw/nftables-default.conf;
  };
  services = {
    haproxy-tailored = import ./haproxy.nix { inherit config; };
    v2ray-tailored = {
      server = (import ../../_parts/v2ray.nix { inherit config; }).server;
    };
  };
}
