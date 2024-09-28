{ config, ... }: {
  imports = [
    ../../_parts/distributed-builder.nix
    ../../_parts/vserver.nix
    ../../_parts/vserver-wss.nix
    ./hydra.nix
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
