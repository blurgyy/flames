{ ... }:

let
  defaultGateway = {
    address = "10.76.0.10";
    interface = "eth0";
  };
  address = "10.76.2.80";
  prefixLength = 21;
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
