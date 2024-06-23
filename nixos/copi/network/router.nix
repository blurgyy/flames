{ lib, pkgs, ... }:

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

  systemd.services = {
    reload-dwmac-sun8i = {
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = [ "-${pkgs.kmod}/bin/modprobe -r dwmac-sun8i" ];
        ExecStart = [ "${pkgs.kmod}/bin/modprobe dwmac-sun8i" ];
        CapabilityBoundingSet = [ "CAP_SYS_MODULE" ];
        AmbientCapabilities = [ "CAP_SYS_MODULE" ];
      };
    };
  };

  # systemd.services.sing-box.serviceConfig.ExecStartPre = lib.mkBefore [
  #   "${pkgs.kmod}/bin/modprobe -r dwmac-sun8i"
  #   "${pkgs.kmod}/bin/modprobe dwmac-sun8i"
  # ];
}
