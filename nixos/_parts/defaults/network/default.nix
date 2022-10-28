{ config, lib, ... }: {
  services.tailscale.enable = true;
  networking.resolvconf.extraConfig = lib.mkAfter "search_domains=tail7a730.ts.net";  # use `tailscale up --accept-dns=false`
  boot.kernel.sysctl = {  # use `tailscale up --advertise-exit-node`
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.firewall-tailored = {
    enable = true;
    acceptedPorts = [ "ssh" "http" "https" ] ++ [{
      port = config.services.tailscale.port;
      protocols = [ "udp" ];
      comment = "tailscale tunnel listening port";
    }];
    rejectedAddrGroups = [{
      addrs = (import ./banned-ips/ssh-scanners.nix);
      comment = "reject known ssh scanners";
    } {
      addrs = (import ./banned-ips/smtp-scanners.nix);
      comment = "reject known smtp scanners";
    }];
    referredServices = [];
  };
}
