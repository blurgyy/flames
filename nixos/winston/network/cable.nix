{ ... }:

let
  defaultGateway = {
    address = "192.168.2.1";
    interface = "eth0";
  };
  address = "192.168.2.2";
  prefixLength = 24;
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
