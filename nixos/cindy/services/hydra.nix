{ config, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
  cacheDomain = "cache.${config.networking.domain}";
in {
  sops.secrets = {
    nix-serve-key = {};
    hydra-distributed-builder-key = {
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
    hydra-queue-runner.environment.GIT_SSH_COMMAND = "ssh -i ${config.sops.secrets.hydra-distributed-builder-key.path} -oKnownHostsFile=/etc/ssh/ssh_known_hosts";
  };
  nix.buildMachines = [{
    hostName = "localhost";
    system = "aarch64-linux";
    maxJobs = 4;
    supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
  } {
    hostName = "peterpan";
    sshUser = "hydra-distributed-builder";
    sshKey = config.sops.secrets.hydra-distributed-builder-key.path;
    ## A publicHostKey entry in /etc/nix/machines will be recognized as in the "mandatory features"
    ## field, causing no build being distributed to the machine.  A hacky work around is to accept
    ## the host key via:
    ## ```shell
    ## $ sudo su - hydra-queue-runner`
    ## $ nix store ping --store ssh://<user>@<host>?ssh-key=<keypath>  # Accept host key here
    ## ```
    ## Currently this configuration adds peterpan's host key to system-wide known hosts, which seems
    ## to be a better approach.
    #publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU5jdkNTd0pNQUN2eGFUWkZlWGVuSS9IdVNFRU1wZkJtSndZUUUwUnN3bU4gcm9vdEBwZXRlcnBhbgo=";
    systems = [ "x86_64-linux" "i686-linux" ];
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
