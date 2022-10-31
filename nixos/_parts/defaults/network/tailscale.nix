{ lib, ... }: let
  tailnet = "tail7a730.ts.net";
in {
  services.tailscale.enable = true;
  networking.resolvconf.extraConfig = lib.mkAfter "search_domains=${tailnet}";  # If managing DNS manually instead of using systemd-resolved, use `tailscale up --accept-dns=false`
  boot.kernel.sysctl = {  # use `tailscale up --advertise-exit-node`
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.firewall-tailored.extraForwardRules = [''
    iifname "tailscale0" accept
    oifname "tailscale0" accept
  ''];
}
