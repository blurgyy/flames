{ config, ... }: {
  sops.secrets = {
    "v2ray/observatory-probe-url" = {};
    "v2ray/ports/http" = {};
    "v2ray/ports/socks" = {};
    "v2ray/ports/tproxy" = {};
    "v2ray/ws-path" = {};
    "v2ray/id" = {};
    "v2ray/domains/eu-00" = {};
    "v2ray/domains/hk-00" = {};
    "v2ray/domains/us-00" = {};
    "v2ray/domains/wss-eu-00" = {};
    "v2ray/domains/wss-us-00" = {};
    "v2ray/addresses/cn-00" = {};
    "v2ray/addresses/eu-00" = {};
    "v2ray/addresses/hk-00" = {};
    "v2ray/addresses/us-00" = {};
  };
  services.v2ray-tailored.client = (import ../../_parts/v2ray.nix { inherit config; }).client;
}
