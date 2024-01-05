{ config, ... }: {
  sops.secrets = builtins.listToAttrs (map
    (secret: {
      name = secret;
      value = {};
    })
    (import ./proxy-client-secrets.nix).default
  );

  services.v2ray-tailored.client = {
    logging.level = "warning";
    enable = true;
    uuid = config.sops.placeholder."v2ray/id";
    soMark = 27;
    fwMark = 39283;
    ports.http = config.sops.placeholder."v2ray/ports/client/http";
    ports.socks = config.sops.placeholder."v2ray/ports/client/socks";
    ports.tproxy = config.sops.placeholder."v2ray/ports/client/tproxy";
    transparentProxying = {
      enable = !(config.wsl.enable or false);
      proxiedSystemServices = [ "nix-daemon.service" ];
    };
    remotes = [
      rec {
        tag = "us-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/${tag}";
        wsPath = null;
      }
      rec {
        tag = "us-01";
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
        tag = "eu-01";
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
      {
        tag = "wss-eu-01";
        address = config.sops.placeholder."v2ray/domains/eu-01";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/eu-01";
        wsPath = config.sops.placeholder."v2ray/ws-path";
      }
    ];
  };
}
