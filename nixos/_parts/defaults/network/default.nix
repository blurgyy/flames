{ ... }: {
  networking.firewall-tailored = {
    enable = true;
    acceptedPorts = [ "ssh" "http" "https" ];
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
