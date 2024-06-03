{ config, ... }: {
  imports = [
    ../../_parts/vserver.nix
    ../../_parts/vserver-wss.nix
    ./ntfy.nix
    ./rssbot.nix
    ./ollama-dev-at-kaggle.nix
  ];
  services.haproxy-tailored = {
    enable = true;
    frontends.tls-offload-front = {
      domain = {
        acme = {
          enable = true;
          email = "gy@blurgy.xyz";
          credentialsFile = config.sops.secrets.acme-credentials-file.path;
        };
      };
    };
  };
}
