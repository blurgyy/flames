{ config, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
  cacheDomain = "cache.${config.networking.domain}";
in {
  sops.secrets.nix-serve-key = {};
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [
        { name = "is_hydra"; body = "hdr(host) -i ${hydraDomain}"; }
        { name = "is_cache"; body = "hdr(host) -i ${cacheDomain}"; }
      ];
      domain.extraNames = [ hydraDomain cacheDomain ];
    };
    backends.hydra = {
      mode = "http";
      options = [ "forwardfor" ];
      requestRules = [ "set-header X-Forwarded-Proto https" ];  # NOTE: Needed to prevent "Mixed Content" while loading website assets (like *.js and *.css)
      server.address = "127.0.0.1:${toString config.services.hydra.port}";
    };
    backends.cache = {
      mode = "http";
      server.address = "127.0.0.1:${toString config.services.nix-serve.port}";
    };
  };
  services.hydra = {
    enable = true;
    hydraURL = "${hydraDomain}";
    notificationSender = "hydra@${config.networking.domain}";
    listenHost = "127.0.0.1";
    port = 5813;
    useSubstitutes = true;
    buildMachinesFiles = [ "/etc/nix/machines" ];
  };
  systemd.services.hydra-evaluator.environment.GC_DONT_GC = "true";  # REF: <https://github.com/NixOS/nix/issues/4178#issuecomment-738886808>
  nix.buildMachines = [
    {
      hostName = "localhost";
      systems = [ "builtin" "x86_64-linux" "aarch64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" ];
    }
  ];
  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1";
    port = 25369;
    secretKeyFile = config.sops.secrets.nix-serve-key.path;
  };
}
