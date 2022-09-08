{ config, pkgs, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
  cacheDomain = "cache.${config.networking.domain}";
in {
  sops.secrets = {
    nix-serve-key = {};
    hydra-git-fetcher-ssh-key = {
      owner = config.users.users.hydra-queue-runner.name;
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
      backends = [
        { name = "hydra"; condition = "if is_hydra"; }
        { name = "cache"; condition = "if is_cache"; }
      ];
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
    package = pkgs.hydra;
    hydraURL = "${hydraDomain}";
    notificationSender = "hydra@${config.networking.domain}";
    listenHost = "127.0.0.1";
    port = 5813;
    useSubstitutes = true;
    buildMachinesFiles = [ "/etc/nix/machines" ];
    extraConfig = ''
      max_output_size = ${toString (8 * 1024 * 1024 * 1024)}
      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>
    '';
  };
  systemd.services = {
    hydra-evaluator.environment.GC_DONT_GC = "true";  # REF: <https://github.com/NixOS/nix/issues/4178#issuecomment-738886808>
    hydra-queue-runner.environment.GIT_SSH_COMMAND = "ssh -i ${config.sops.secrets.hydra-git-fetcher-ssh-key.path}";
  };
  nix.buildMachines = [{
    hostName = "localhost";
    systems = [ "aarch64-linux" "x86_64-linux" "i686-linux" ];
    maxJobs = 4;
    supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
  }];
  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1";
    port = 25369;
    secretKeyFile = config.sops.secrets.nix-serve-key.path;
  };
}
