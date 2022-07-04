{ config, lib, pkgs, ... }: let
  rathole-config-content = pkgs.toTOML {
    client.remote_addr = config.sops.placeholder."rathole/remote_addr";
    client.services = {
      "ssh-${config.networking.hostName}" = {
        token = config.sops.placeholder."rathole/ssh/token";
        local_addr = "127.1:22";
      };
      "acremote-${config.networking.hostName}" = {
        token = config.sops.placeholder."rathole/acremote/token";
        local_addr = "127.1:12682";
      };
    };
  };
in {
  networking.nftables.ruleset = builtins.readFile ../_parts/raw/nftables-default.conf;
  services.v2ray-tailored = {
    client = {
      enable = true;
      uuid = config.sops.placeholder."v2ray/users/a/id";
      soMark = 27;
      fwMark = 39283;
      ports.http = config.sops.placeholder."v2ray/ports/http";
      ports.socks = config.sops.placeholder."v2ray/ports/socks";
      ports.tproxy = config.sops.placeholder."v2ray/ports/tproxy";
      remotes = [
        rec {
          tag = "us-00";
          address = config.sops.placeholder."v2ray/addresses/${tag}";
          port = 443;
          domain = config.sops.placeholder."v2ray/domains/${tag}";
          wsPath = null;
        }
        rec {
          tag = "eu-00";
          address = config.sops.placeholder."v2ray/addresses/${tag}";
          port = 443;
          domain = config.sops.placeholder."v2ray/domains/${tag}";
          wsPath = null;
        }
        rec {
          tag = "cn-00";
          address = config.sops.placeholder."v2ray/addresses/${tag}";
          port = 443;
          domain = config.sops.placeholder."v2ray/addresses/${tag}";
          wsPath = null;
          allowInsecure = true;
        }
        rec {
          tag = "wss-us-00";
          address = config.sops.placeholder."v2ray/domains/us-00";
          port = 443;
          domain = config.sops.placeholder."v2ray/domains/us-00";
          wsPath = config.sops.placeholder."v2ray/ws-path";
        }
        rec {
          tag = "wss-eu-00";
          address = config.sops.placeholder."v2ray/domains/eu-00";
          port = 443;
          domain = config.sops.placeholder."v2ray/domains/eu-00";
          wsPath = config.sops.placeholder."v2ray/ws-path";
        }
      ];
      extraHosts = {
        "hooper" = config.sops.placeholder."server-addresses/hooper";
        "peterpan" = config.sops.placeholder."server-addresses/peterpan";
        "cindy" = config.sops.placeholder."server-addresses/cindy";
        "watson" = config.sops.placeholder."server-addresses/watson";
      };
    };
  };
  services.rathole = {
    enable = true;
    configFile = config.sops.templates.rathole-config.path;
  };
  sops.templates.rathole-config.content = rathole-config-content;
}
