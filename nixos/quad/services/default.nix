{ config, ... }: {
  imports = [
    ./ntfy.nix
    ./v2ray.nix
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
