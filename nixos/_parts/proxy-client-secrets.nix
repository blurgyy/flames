rec {
  domains = [
    "v2ray/domains/eu-00"
    "v2ray/domains/eu-01"
    "v2ray/domains/jp-00"
    "v2ray/domains/us-00"
    "v2ray/domains/us-01"
  ];
  addresses = [
    "v2ray/domains/wss-eu-00"
    "v2ray/domains/wss-eu-01"
    "v2ray/addresses/cn-00"
    "v2ray/addresses/eu-00"
    "v2ray/addresses/eu-01"
    "v2ray/addresses/jp-00"
    "v2ray/addresses/us-00"
    "v2ray/addresses/us-01"
  ];
  misc = [
    "v2ray/observatory-probe-url"
    "v2ray/ws-path"
    "v2ray/id"
  ];
  ports = [
    "v2ray/ports/client/http"
    "v2ray/ports/client/socks"
    "v2ray/ports/client/tproxy"
  ];

  default = domains ++ addresses ++ misc ++ ports;
}
