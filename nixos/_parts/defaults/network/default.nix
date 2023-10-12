{ config, ... }: {
  imports = [
    ./tailscale.nix
  ];

  networking.firewall-tailored = {
    enable = true;
    acceptedPorts = [ "ssh" "http" "https" ] ++ [{
      port = config.services.tailscale.port;
      protocols = [ "udp" ];
      comment = "tailscale tunnel listening port";
    } {
      port = "1714-1764";
      protocols = [ "tcp" "udp" ];
      comment = "KDEConnect communication ports";
    }];
    rejectedAddrGroups = [{
      addrs = (import ./banned-ips/ssh-scanners.nix);
      countPackets = true;
      comment = "reject known ssh scanners";
    } {
      addrs = (import ./banned-ips/smtp-scanners.nix);
      countPackets = true;
      comment = "reject known smtp scanners";
    } {
      addrs = (import ./banned-ips/http-proxy-scanners.nix);
      countPackets = true;
      comment = "reject known http-proxy scanners";
    }];
    acceptedAddrGroups = [{
      addrs = [ "$private_range" ];
      countPackets = true;
      comment = "allow machiines from private network to access arbitrary port";
    }];
    referredServices = [];
  };
}
