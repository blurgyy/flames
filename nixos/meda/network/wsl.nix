{ ... }:

let
  # find gateway and prefixLength from windows powershell with command `ipconfig /all`, look for the
  # section with name "vEthernet (WSL)"
  defaultGateway = {
    address = "172.30.96.1";
    interface = "eth0";
  };
  # this can be arbitrary non-gateway address that satisfies prefixLength.
  address = "172.30.96.169";
  prefixLength = 20;
in

{
  networking = {
    inherit defaultGateway;
    interfaces.${defaultGateway.interface} = {
      useDHCP = false;
      # trying to ssh on to this machine with `-vvvvvvvvvv` hangs at:
      #   debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
      # REF:
      #   * <https://serverfault.com/q/210408>
      #   * <https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/1254085/comments/9>
      mtu = 1500;
      ipv4.addresses = [{ inherit address prefixLength; }];
    };
  };
}
