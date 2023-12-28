{ ... }:

let
  defaultGateway = {
    address = "74.48.91.65";
    interface = "eth0";
  };
  address = "74.48.91.105";
  prefixLength = 26;
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
