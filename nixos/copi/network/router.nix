{ ... }:

/*
 * connect winston through cable with this machine to route winston's traffic via WiFi
 */

{
  networking = {
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.2.1";
      prefixLength = 24;
    }];
    nat = {
      enable = true;
      externalInterface = "wlan0";  # traffic goes out via this interface
      internalInterfaces = [ "eth0" ];  # traffic from these interfaces are routed
    };
  };
}
