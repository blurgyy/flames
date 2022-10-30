{ lib, ... }: {
  services.tailscale.enable = true;
  networking.resolvconf.extraConfig = lib.mkAfter "search_domains=tail7a730.ts.net";  # use `tailscale up --accept-dns=false`
  boot.kernel.sysctl = {  # use `tailscale up --advertise-exit-node`
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.firewall-tailored.extraForwardRules = [''
    iifname "tailscale0" accept
    oifname "tailscale0" accept
  ''];
}
