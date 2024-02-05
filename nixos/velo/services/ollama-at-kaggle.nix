{ config, ... }:

let
  controlPanelDomain = "ollama.${config.networking.domain}";
  chatDomain = "chat.${config.networking.domain}";

  controlPanelPort = 18572;
  chatPort = 23989;
in

{
  services.ssh-reverse-proxy.server = {
    services.ollama-at-kaggle = {
      port = chatPort;
      expose = false;
    };
    extraKnownHosts = [
      (import ../../_parts/defaults/public-keys.nix).services.ollama-at-kaggle
    ];
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      domain.extraNames = [ controlPanelDomain chatDomain ];
      acls = [
        { name = "is_control_panel"; body = "hdr(host) -i ${controlPanelDomain}"; }
        { name = "is_chat"; body = "hdr(host) -i ${chatDomain}"; }
      ];
      backends = [
        { name = "chat"; condition = "if is_chat"; }
        { name = "control-panel"; condition = "if is_control_panel"; isDefault = true; }
      ];
    };
    backends.chat = {
      mode = "http";
      server.address = "127.0.0.1:${toString chatPort}";
    };
    backends.control-panel = {
      mode = "http";
      server.address = "127.0.0.1:${toString controlPanelPort}";
    };
  };
}
