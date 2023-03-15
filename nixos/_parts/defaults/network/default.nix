{ config, lib, ... }: {
  imports = [
    ./dns
    ./tailscale.nix
  ];

  networking.firewall-tailored = {
    enable = true;
    acceptedPorts = [ "ssh" "http" "https" ] ++ [{
      port = config.services.tailscale.port;
      protocols = [ "udp" ];
      comment = "tailscale tunnel listening port";
    }];
    rejectedAddrGroups = [{
      addrs = (import ./banned-ips/ssh-scanners.nix);
      countPackets = true;
      comment = "reject known ssh scanners";
    } {
      addrs = (import ./banned-ips/smtp-scanners.nix);
      countPackets = true;
      comment = "reject known smtp scanners";
    }];
    acceptedAddrGroups = [{
      addrs = [ "$private_range" ];
      countPackets = true;
      comment = "allow machiines from private network to access arbitrary port";
    }];
    referredServices = [];
  };
}
