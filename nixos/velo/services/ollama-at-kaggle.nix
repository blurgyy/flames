{ config, pkgs, inputs, ... }:

let
  controlPanelDomain = "ollama.${config.networking.domain}";
  chatDomain = "chat.${config.networking.domain}";

  controlPanelPort = 3377;
  chatPort = 23989;
in

{
  systemd.services.ollama-at-kaggle = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    script = let
      inherit (pkgs.stdenv.hostPlatform) system;
      configFile = pkgs.writeText "config.toml" ''
        api_server_address = "http://localhost:3287"  # configured from the kaggle side

        [server]
        host = "localhost"
        port = ${toString controlPanelPort}
        www_root = "${inputs.meaney.packages.${system}.meaney-frontend}/share/webapps/meaney"
      '';
    in ''
      ${inputs.meaney.packages.${system}.meaney-backend}/bin/meaney-backend \
        --config-path=${configFile} \
        --chat-server-address=https://${chatDomain}
    '';
  };

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
