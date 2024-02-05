{ ... }:

let
  defaultGateway = {
    address = "64.64.240.1";
    interface = "eth0";
  };
  address = "64.64.240.2";
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
