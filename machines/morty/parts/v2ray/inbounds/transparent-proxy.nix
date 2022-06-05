{ config }: {
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
  settings = {
    network = "tcp,udp";
    followRedirect = true;
  };
  streamSettings.sockopt.tproxy = "tproxy";
  port = config.sops.placeholder."v2ray/ports/tproxy";
  protocol = "dokodemo-door";
}
