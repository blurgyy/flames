{ config, lib, ... }: {
  imports = [ ./tailscale.nix ];
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
