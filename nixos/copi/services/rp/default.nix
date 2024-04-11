{ config, lib, ... }:

let
  proxy-zju-host-port = 8952;
in

{
  imports = [
    ./zjuwlan-condition.nix
  ];

  sops.secrets = {
    "sshrp/ssh-env" = {};
    "sshrp/http-proxy-env" = {};
    "sshrp/socks-proxy-env" = {};
    "sshrp/proxy-zju-env" = {};
  } // (import ../../../_parts/proxy-secrets.nix).server;

  services.ssh-reverse-proxy = {
    client.instances = {
      ssh = {
        environmentFile = config.sops.secrets."sshrp/ssh-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 2856;
        hostPort = builtins.head config.services.openssh.ports;
      };
      http-proxy = {
        environmentFile = config.sops.secrets."sshrp/http-proxy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
      };
      socks-proxy = {
        environmentFile = config.sops.secrets."sshrp/socks-proxy-env".path;
        identityFile = config.sops.secrets.hostKey.path;
      };
      proxy-zju-env = {
        environmentFile = config.sops.secrets."sshrp/proxy-zju-env".path;
        identityFile = config.sops.secrets.hostKey.path;
        bindPort = 2096;
        hostPort = proxy-zju-host-port;
      };
    };
  };

  services.sing-box.settings = let
    inboundTag = "zju-proxy-in";
  in {
    inbounds = [{
      tag = inboundTag;

      type = "vmess";
      listen = "127.0.0.1";
      listen_port = proxy-zju-host-port;
      users = map
        (index: {
          name._secret = config.sops.secrets."v2ray/users/${index}/email".path;
          uuid._secret = config.sops.secrets."v2ray/users/${index}/uuid".path;
        })
        [ "00" "01" "02" "03" "04" "05" ];
    }];
    route.rules = lib.mkBefore [{  # user mkBefore to prioritize this direct rule
      inbound = inboundTag;
      outbound = "direct-zju-internal";
    } {
      domain_suffix = "@custom/25-zju-domain-suffix@";
      domain_keyword = "@custom/25-zju-domain-keyword@";
      ip_cidr = "@custom/25-zju-ip@";
      outbound = "direct-zju-internal";
    }];
  };
}
