{ ... }:

let
  defaultGateway = {
    address = "193.32.148.1";
    interface = "eth0";
  };
  address = "193.32.151.152";
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
