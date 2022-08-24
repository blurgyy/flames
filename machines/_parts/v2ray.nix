{ config }: {
  client = {
    enable = true;
    uuid = config.sops.placeholder."v2ray/id";
    soMark = 27;
    fwMark = 39283;
    ports.http = config.sops.placeholder."v2ray/ports/http";
    ports.socks = config.sops.placeholder."v2ray/ports/socks";
    ports.tproxy = config.sops.placeholder."v2ray/ports/tproxy";
    remotes = [
      rec {
        tag = "us-00";
        address = config.sops.placeholder."v2ray/addresses/${tag}";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/${tag}";
        wsPath = null;
      }
      rec {
        tag = "hk-00";
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
      rec {
        tag = "wss-us-00";
        address = config.sops.placeholder."v2ray/domains/us-00";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/us-00";
        wsPath = config.sops.placeholder."v2ray/ws-path";
      }
      rec {
        tag = "wss-eu-00";
        address = config.sops.placeholder."v2ray/domains/eu-00";
        port = 443;
        domain = config.sops.placeholder."v2ray/domains/eu-00";
        wsPath = config.sops.placeholder."v2ray/ws-path";
      }
    ];
    overseaSelectors = [ "hk" "us" "wss" ];
  };
}
