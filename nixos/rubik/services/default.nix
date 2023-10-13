{ config, ... }: {
  imports = [
    ./mail.nix
    ./mediaserver.nix
    ./ntfy.nix
    ./router-page.nix
    ./rules-server-clash.nix
    ./rules-server-sing-box.nix
    ./v2ray.nix
  ];
  sops.secrets.acme-credentials-file = { owner = config.users.users.haproxy.name; };
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
