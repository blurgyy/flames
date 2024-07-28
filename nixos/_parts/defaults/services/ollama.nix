{ config, ... }:

{
  sops.secrets."ollama-privatekey" = {
    path = "/var/lib/${toString config.systemd.services.ollama.serviceConfig.StateDirectory}/.ollama/id_ed25519";
    sopsFile = ../../../_secrets.yaml;
  };
  services.ollama.enable = true;
}
