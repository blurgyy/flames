{ ... }:

let
  defaultGateway = {
    address = "172.19.3.1";
    interface = "eth0";
  };
  address = "172.19.3.14";
  prefixLength = 24;
in

{
  imports = [
    ../../_parts/sing-box.nix
  ];

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
