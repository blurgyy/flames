{ ... }:

let
  # find gateway and prefixLength from windows powershell with command `ipconfig /all`, look for the
  # section with name "vEthernet (WSL)"
  gateway = "172.30.96.1";
  prefixLength = 20;
in

{
  networking = {
    defaultGateway = gateway;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        inherit prefixLength;
        # this can be arbitrary non-gateway address that satisfies prefixLength.
        address = "172.30.96.169";
      }];
    };
  };

  systemd.services.nix-daemon.environment = let
    # need to open this port on the Windows side
    port = 9990;
  in {
    http_proxy = "http://${gateway}:${toString port}";
    https_proxy = "http://${gateway}:${toString port}";
  };
}
