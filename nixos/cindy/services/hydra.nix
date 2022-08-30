{ config, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
  cacheDomain = "cache.${config.networking.domain}";
in {
  sops.secrets = {
    nix-serve-key = {};
    peterpan-hydra-builder-key = {
      owner = config.users.users.hydra.name;
      group = config.users.groups.hydra.name;
    };
  };
  nix.extraOptions = ''
    # Allow hydra to build homeConfigurations.*.activationPackage
    # REF: <https://github.com/cleverca22/nixos-configs/blob/33d05ae5881f637bec254b545b323f37ba3acf2e/nas-hydra.nix#L17>
    # Related: <https://github.com/NixOS/nix/issues/1888>
    allowed-uris = https://github.com/cleverca22/nix-tests https://gitlab.com/api/v4/projects/rycee%2Fnmd
  '';
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
  nix.buildMachines = [{
      hostName = "localhost";
      system = "aarch64-linux";
      supportedFeatures = [ "benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test" ];
  } {
      hostName = "81.69.28.75";
      sshUser = "hydra-builder";
      sshKey = config.sops.secrets.peterpan-hydra-builder-key.path;
      publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5jdkNTd0pNQUN2eGFUWkZlWGVuSS9IdVNFRU1wZkJtSndZUUUwUnN3bU4gcm9vdEBwZXRlcnBhbgo=";
      system = "x86_64-linux";
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
  }];
  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1";
    port = 25369;
    secretKeyFile = config.sops.secrets.nix-serve-key.path;
  };
}
