{ ... }:

let
  defaultGateway = {
    address = "45.139.193.1";
    interface = "eth0";
  };
  address = "45.139.193.21";
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
