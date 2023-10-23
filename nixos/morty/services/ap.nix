{ config, lib, ... }:

let
  internalIP = "192.168.169.1/24";
in

{
  sops.secrets."ap-password" = {};

  networking.wireless.interfaces = [ "wlan0_sta" ];
  networking.wlanInterfaces = {
    wlan0_sta.device = "wlan0";
    wlan0_ap.device = "wlan0";
  };

  services.hostapd = {
    enable = true;
    radios = {
      wlan0_ap = {
        networks.wlan0_ap = {  # Exactly one network must be named like the radio, for reasons internal to hostapd.
          ssid = "${config.networking.hostName}.ap";
          authentication = {
            mode = "wpa3-sae-transition";
            # saePasswords = [{ passwordFile = config.sops.secrets."ap-password".path; }];
            saePasswordsFile = config.sops.secrets."ap-password".path;
            wpaPasswordFile = config.sops.secrets."ap-password".path;
          };
        };
      };
    };
  };

  systemd.network.networks = {
    "40-wlan0_sta" = {
      name = "wlan0_sta";
      networkConfig.DHCP = "yes";
      linkConfig.RequiredForOnline = true;
    };
    "40-wlan0_ap" = {
      address = [ internalIP ];
      name = "wlan0_ap";
      linkConfig.RequiredForOnline = false;
      networkConfig = {
        DHCPServer = true;
      };
      dhcpServerConfig = {
        ServerAddress = internalIP;
        PoolOffset = 169;
        PoolSize = 13;
        DNS = builtins.head (lib.splitString "/" internalIP);
        EmitDNS = true;
      };
    };
  };

  networking.firewall-tailored.acceptedPorts = [{
    port = 67;
    protocols = [ "udp" ];
    comment = "Packets sent to the DHCP server on this host";
  } {
    # use in conjuction with prerouting dnat rule and masquerade the destination address of the
    # forwarded packet
    port = 53;
    protocols = [ "udp" ];
    comment = "Packets sent to the DNS server on this host";
  }];

  networking.firewall-tailored = {
    extraForwardRules = [''
      ct state related,established accept
      iifname "wlan0_ap" accept
      oifname "wlan0_sta" accept
    ''];
    extraRulesAfter = [''
      table inet nat
      delete table inet nat
      table inet nat {
        chain prerouting {
          type nat hook prerouting priority -100
          meta l4proto { tcp, udp } th dport 53 dnat ip to ${config.services.sing-box.tunDnsAddress}
        }

        chain postrouting {
          type nat hook postrouting priority 100
          policy accept
          oifname "wlan0_sta" masquerade
          ip daddr ${config.services.sing-box.tunDnsAddress} masquerade
        }
      }
    ''];
  };
}
