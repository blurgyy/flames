{ ... }:

let
  defaultGateway = {
    address = "45.78.20.1";
    interface = "eth0";
  };
  address = "45.78.21.202";
  prefixLength = 22;
in

{
  networking = {
    inherit defaultGateway;
    interfaces.${defaultGateway.interface} = {
      useDHCP = false;
      ipv4.addresses = [{ inherit address prefixLength; }];
    };
  };

  systemd.network.networks."40-${defaultGateway.interface}" = {
    name = defaultGateway.interface;
    linkConfig.RequiredForOnline = true;
  };
}
