{ config, lib, ... }: {
  services.tailscale.enable = true;
  networking.resolvconf.extraConfig = lib.mkAfter "search_domains=tail7a730.ts.net";  # use `tailscale up --accept-dns=false`
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
