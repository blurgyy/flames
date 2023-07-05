{ ... }: {
  networking = {
    defaultGateway = "10.76.0.10";
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.76.2.80";
        prefixLength = 21;
      }];
    };
  };
}
