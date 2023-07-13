{ config, ... }: {
  sops.secrets = {
    "v2ray/observatory-probe-url" = {};
    "v2ray/ports/client/http" = {};
    "v2ray/ports/client/socks" = {};
    "v2ray/ports/client/tproxy" = {};
    "v2ray/ws-path" = {};
    "v2ray/id" = {};
    "v2ray/domains/eu-00" = {};
    "v2ray/domains/jp-00" = {};
    "v2ray/domains/us-00" = {};
    "v2ray/domains/wss-eu-00" = {};
    "v2ray/addresses/cn-00" = {};
    "v2ray/addresses/eu-00" = {};
    "v2ray/addresses/jp-00" = {};
    "v2ray/addresses/us-00" = {};
  };
  services.v2ray-tailored.client = {
    logging.level = "warning";
    enable = true;
    uuid = config.sops.placeholder."v2ray/id";
    soMark = 27;
    fwMark = 39283;
    ports.http = config.sops.placeholder."v2ray/ports/client/http";
    ports.socks = config.sops.placeholder."v2ray/ports/client/socks";
    ports.tproxy = config.sops.placeholder."v2ray/ports/client/tproxy";
    proxiedSystemServices = [ "nix-daemon.service" ];
    remotes = [
      rec {
        tag = "us-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/${tag}";
        wsPath = null;
      }
      rec {
        tag = "jp-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/${tag}";
        wsPath = null;
      }
      rec {
        tag = "eu-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/${tag}";
        wsPath = null;
      }
      rec {
        tag = "cn-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/addresses/${tag}";
        wsPath = null;
        allowInsecure = true;
      }
      {
        tag = "wss-eu-00";
        address = config.sops.placeholder."v2ray/domains/eu-00";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/eu-00";
        wsPath = config.sops.placeholder."v2ray/ws-path";
      }
    ];
  };
}
