{ config, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
in {
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_hydra"; body = "hdr(host) -i ${hydraDomain}"; } ];
      domain.extraNames = [ hydraDomain ];
    };
    backends.hydra = {
      mode = "http";
      options = [ "forwardfor" ];
      requestRules = [ "set-header X-Forwarded-Proto https" ];  # NOTE: Needed to prevent "Mixed Content" while loading website assets (like *.js and *.css)
      server.address = "127.0.0.1:5813";
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
  nix.buildMachines = [
    {
      hostName = "localhost";
      systems = [ "builtin" "x86_64-linux" "aarch64-linux" ];
      supportedFeatures = [ "nixos-test" "benchmark" ];
    }
  ];
}
