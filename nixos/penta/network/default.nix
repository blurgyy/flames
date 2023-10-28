{ ... }:

let
  defaultGateway = {
    address = "109.71.253.1";
    interface = "eth0";
  };
  address = "109.71.253.196";
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

  systemd.network.wait-online.extraArgs = [ "--interface=eth0" ];
}
