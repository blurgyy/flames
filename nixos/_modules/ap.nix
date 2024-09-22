{ config, lib, ... }:

with lib;

let
  cfg = config.networking.ap;
in

{
  options.networking.ap = {
    enable = mkEnableOption "Whether to enable software access point";
    apInterface = mkOption {
      type = types.str;
      description = "Name of the interface to run the AP on";
    };
    destinationInterface = mkOption {
      type = types.str;
      description = "Name of the interface to forward the packets from AP to";
    };
    address = mkOption {
      type = types.str;
      description = "Address (with prefix) of this machine as seen from devices connected to the ap";
    };
    dnsAddress = mkOption {
      type = types.str;
      description = "UDP packets sent to this machine's port 53 are forwarded to this address";
    };
    passwordFile = mkOption {
      type = types.str;
      description = "Path to a file containing the password";
    };
    dhcpPoolOffset = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Configures the `PoolOffset=` directive in man:systemd.network(5)'s [DHCPServer] section
      '';
    };
    dhcpPoolSize = mkOption {
      type = types.int;
      default = 13;
      description = ''
        Configures the `PoolSize=` directive in man:systemd.network(5)'s [DHCPServer] section
      '';
    };
  };

  config = mkIf cfg.enable {
    services.hostapd = {
      enable = true;
      radios = {
        ${cfg.apInterface}.networks.${cfg.apInterface} = {  # Exactly one network must be named like the radio, for reasons internal to hostapd.
          ssid = "${config.networking.hostName}.ap";
          authentication = {
            mode = "wpa2-sha1";
            # mode = "wpa3-sae-transition";
            # saePasswordsFile = cfg.passwordFile;
            wpaPasswordFile = cfg.passwordFile;
          };
        };
      };
    };

    systemd.services.hostapd.serviceConfig = {
      Restart = "always";
      RestartSec = 5;
    };

    systemd.network.networks = {
      "40-${cfg.destinationInterface}" = {
        name = cfg.destinationInterface;
        linkConfig.RequiredForOnline = true;
      };
      "40-${cfg.apInterface}" = {
        name = cfg.apInterface;
        address = [ cfg.address ];
        linkConfig.RequiredForOnline = false;
        networkConfig.DHCPServer = true;
        dhcpServerConfig = {
          ServerAddress = cfg.address;
          PoolOffset = cfg.dhcpPoolOffset;
          PoolSize = cfg.dhcpPoolSize;
          DNS = builtins.head (lib.splitString "/" cfg.address);
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
        iifname "${cfg.apInterface}" accept
        oifname "${cfg.destinationInterface}" accept
      ''];
      extraRulesAfter = [''
        table inet nat
        delete table inet nat
        table inet nat {
          chain prerouting {
            type nat hook prerouting priority -100
            meta l4proto { udp } th dport 53 dnat ip to ${cfg.dnsAddress}
          }

          chain postrouting {
            type nat hook postrouting priority 100
            policy accept
            oifname "${cfg.destinationInterface}" masquerade
            ip daddr ${cfg.dnsAddress} masquerade
          }
        }
      ''];
    };
  };
}
