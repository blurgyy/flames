{ config, ... }: {
  imports = [
    ../../_parts/distributed-builder.nix
    ../../_parts/vserver.nix
    ../../_parts/vserver-wss.nix
    ./containers.nix
    ./ntfy.nix
    ./ollama-dev-at-kaggle.nix

    ./hydra.nix
    ./rssbot.nix
    ./vaultwarden
    ./wakapi.nix
    ./webdav.nix
  ];
  sops.secrets.acme-credentials-file = with config.users; {
    owner = users.haproxy.name;
    group = groups.haproxy.name;
  };
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
