{ config, lib, pkgs, ... }: let
  cfg = config.services.ssh-reverse-proxy;
in with lib; {
  options.services.ssh-reverse-proxy = let
    hostInstanceModule = types.submodule ({ ... }: {
      options = {
        environmentFile = mkOption {
          type = types.str;
          default = null;
          description = ''
            Environment file that contains 2 entries:
            * REMOTE: the hostname of the remote machine to login to.
            * BIND_ADDR: TCP listening address on the remote (see man:ssh(1) -R `bind_addr`).
          '';
        };
        identityFile = mkOption { type = types.str; default = null; };
        bindPort = mkOption {
          type = with types; oneOf [ int str ];
          default = null;
          description = "Specify which port is exposed on the remote machine";
        };
        hostPort = mkOption {
          type = with types; oneOf [ int str ];
          default = null;
          description = "Specify which port is connected to on the host machine";
        };
        user = mkOption {
          type = types.str;
          default = "sshrp";
          description = "Username on remote machine to accept login";
        };
        extraSSHOptions = mkOption {
          type = with types; attrsOf (oneOf [ int str ]);
          default = {};
        };
      };
    });
    remoteServiceModule = types.submodule ({ ... }: {
      options = {
        port = mkOption {
          type = with types; oneOf [ str int ];
          default = null;
        };
        expose = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to expose this service's port to the public";
        };
      };
    });
  in {
    client = {
      defaultSSHOptions = mkOption {
        type = with types; attrsOf (oneOf [ int str ]);
        default = {};
      };
      instances = mkOption {
        type = types.attrsOf hostInstanceModule;
        default = {};
      };
    };
    server = {
      services = mkOption {
        type = with types; attrsOf remoteServiceModule;
        default = {};
      };
      extraKnownHosts = mkOption {
        type = with types; listOf str;
        default = [];
      };
    };
  };

  config = let
    nonEmpty = l: (builtins.length l) > 0;
    asRemote = nonEmpty (attrValues cfg.server.services);
  in {
    services.ssh-reverse-proxy.client.defaultSSHOptions = {
      Compression = "yes";
      ControlMaster = "no";
      IPQoS = "none";
      ServerAliveCountMax = 3;
      ServerAliveInterval = 5;
      StrictHostKeyChecking = "no";
      UserKnownHostsFile = "/dev/null";
    };

    services.openssh.settings.GatewayPorts = mkIf asRemote "clientspecified";  # allow listening on all interfaces while using port forwarding
    networking.firewall-tailored.acceptedPorts = mkIf asRemote (let
      mkPortCfg = svc: svcCfg: {
        inherit (svcCfg) port;
        comment = "Reverse ssh port forwarding for service '${svc}'";
        protocols = [ "tcp" ];  # ssh port forwarding works with TCP traffic
      };
    in attrValues
      (mapAttrs
        mkPortCfg
        (filterAttrs
          (svc: svcCfg: svcCfg.expose)
          cfg.server.services)
        )
      );
    users = mkIf asRemote {
      users.sshrp = {
        isSystemUser = true;
        group = config.users.groups.sshrp.name;
        shell = "/run/current-system/sw/bin/nologin";
        openssh.authorizedKeys.keys = let
          keys = import ../_parts/defaults/public-keys.nix;
          hostKeys = builtins.attrValues keys.hosts;
        in hostKeys ++ cfg.server.extraKnownHosts;
      };
      groups.sshrp = {};
    };
    systemd.services = let
      mkSSHOptions = sshOptions: concatStringsSep " "
        (with builtins; attrValues
          (mapAttrs
            (k: v: "-o${k}=${toString v}")
            sshOptions
          )
        );
      mkService = name: instance: {
        name = "rp-${name}";
        description = "Reverse ssh port forwarding for service '${svc}'";
        documentation = [ "man:ssh(1)" ];
        value = {
          path = [ pkgs.openssh ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            EnvironmentFile = instance.environmentFile;
            Restart = "always";
            RestartSec = 5;
            DynamicUser = true;
            LoadCredential = "id:${instance.identityFile}";
          };
          script = ''
            ssh "$REMOTE" \
              -NR "$BIND_ADDR:${toString instance.bindPort}:localhost:${toString instance.hostPort}" \
              -oUser="${instance.user}" \
              -oIdentityFile="$CREDENTIALS_DIRECTORY/id" \
              ${mkSSHOptions cfg.client.defaultSSHOptions} \
              ${mkSSHOptions instance.extraSSHOptions}
          '';
        };
      };
      mkServices = instances: attrValues (mapAttrs mkService instances);
    in lib.listToAttrs (mkServices cfg.client.instances);
  };
}
