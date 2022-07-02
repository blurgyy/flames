{ ports }: {
  sniffing = {
    enabled = true;
    destOverride = [ "http" "tls" ];
  };
  settings = {
    network = "tcp,udp";
    followRedirect = true;
  };
  streamSettings.sockopt.tproxy = "tproxy";
  port = ports.tproxy;
  protocol = "dokodemo-door";
}
