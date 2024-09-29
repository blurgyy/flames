{ config, ... }:

let
  hydraDomain = "hydra.${config.networking.domain}";
  cacheDomain = "cache.${config.networking.domain}";
  cachePort = 25369;
  cachePortFwd = 7735;
in

{
  users.users.hydra.extraGroups = [
    config.users.groups.keys.name  # so that hydra can pull private repositories
  ];

  sops.secrets = let
    owner = config.users.users.hydra-queue-runner.name;
  in {
    cache-key = { mode = "0440"; };
    hydra-git-fetcher-ssh-key = { inherit owner; };
    distributed-builder-ssh-key = { inherit owner; };
    hydra-email-secrets = { inherit owner; };
  };
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [
        { name = "is_hydra"; body = "hdr(host) -i ${hydraDomain}"; }
        { name = "is_cache"; body = "hdr(host) -i ${cacheDomain}"; }
      ];
      domain.extraNames = [ hydraDomain cacheDomain ];
      backends = [
        { name = "hydra"; isDefault = true; condition = "if is_hydra"; }
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
      server.address = "127.0.0.1:${toString cachePortFwd}";
    };
  };
  services.hydra = {
    enable = true;
    # package = pkgs.hydra_unstable;
    hydraURL = "${hydraDomain}";
    notificationSender = "hydra@${config.networking.domain}";
    smtpHost = config.networking.domain;
    listenHost = "127.0.0.1";
    port = 5813;
    useSubstitutes = true;
    buildMachinesFiles = [ "/etc/nix/machines" ];
    extraConfig = ''
      # REF: <https://github.com/NixOS/hydra/blob/f48f00ee6d5727ae3e488cbf9ce157460853fea8/doc/manual/src/projects.md#email-notifications>
      email_notification = 1

      max_output_size = ${toString (8 * 1024 * 1024 * 1024)}

      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>
    '';
  };
  services.harmonia = {
    enable = true;
    signKeyPaths = [
      config.sops.secrets.cache-key.path
    ];
    settings = {
      bind = "127.0.0.1:${toString cachePort}";
    };
  };
  services.zstdp = {
    enable = true;
    services.harmonia = {
      listen = "127.0.0.1:${toString cachePortFwd}";
      forward = "127.0.0.1:${toString cachePort}";
    };
  };
  nix = {
    buildMachines = [{
      hostName = "tom";
      protocol = "ssh";
      sshUser = "distributed-builder";
      sshKey = config.sops.secrets.distributed-builder-ssh-key.path;
      systems = [ "x86_64-linux" "i686-linux" ];
      maxJobs = 4;
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
    } {
      hostName = "jerry";
      protocol = "ssh";
      sshUser = "distributed-builder";
      sshKey = config.sops.secrets.distributed-builder-ssh-key.path;
      systems = [ "aarch64-linux" ];
      maxJobs = 4;
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
    }];
    extraOptions = ''
      # Allow hydra to build homeConfigurations.*.activationPackage
      # REF: <https://github.com/cleverca22/nixos-configs/blob/33d05ae5881f637bec254b545b323f37ba3acf2e/nas-hydra.nix#L17>
      # Related: <https://github.com/NixOS/nix/issues/1888>
      allowed-uris = https:// git+https:// github: gitlab: path:
    '';
  };
}
