{ config, ... }: {
  services = {
    haproxy-tailored = import ./haproxy.nix { inherit config; };
    v2ray-tailored = {
      server = (import ../../_parts/v2ray.nix { inherit config; }).server;
    };
  };
}
