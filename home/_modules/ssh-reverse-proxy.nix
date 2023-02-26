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
          type = with types;
          attrsOf str;
          default = {};
        };
      };
    });
  in {
    defaultSSHOptions = mkOption {
      type = with types; attrsOf (oneOf [ int str ]);
      default = {};
    };
    instances = mkOption {
      type = types.attrsOf hostInstanceModule;
      default = {};
    };
  };

  config = {
    services.ssh-reverse-proxy.defaultSSHOptions = {
      ControlMaster = "no";
      IPQoS = "none";
      ServerAliveCountMax = 3;
      ServerAliveInterval = 5;
      StrictHostKeyChecking = "no";
      UserKnownHostsFile = "/dev/null";
    };

    systemd.user.services = let
      mkSSHOptions = sshOptions: concatStringsSep " "
        (with builtins; attrValues
          (mapAttrs
            (k: v: "-o${k}=${toString v}")
            sshOptions
          )
        );
      mkService = instanceName: instance: {
        name = "rp-${instanceName}";
        value = {
          Unit = {
            Description = "Reverse ssh port forwarding for service '${instanceName}'";
            Documentation = [ "man:ssh(1)" ];
          };
          Install.WantedBy = [ "default.target" ];
          Service = {
            Environment = [ "PATH=${lib.makeBinPath [pkgs.openssh]}" ];
            EnvironmentFile = instance.environmentFile;
            Restart = "always";
            RestartSec = 5;
            ExecStart = let
              scriptName = "rp-${instanceName}-service-start-script";
              command = pkgs.writeShellScriptBin scriptName ''
                ssh "$REMOTE" \
                  -NR "$BIND_ADDR:${toString instance.bindPort}:localhost:${toString instance.hostPort}" \
                  -oUser=${instance.user} \
                  -oIdentityFile=${instance.identityFile} \
                  -oExitOnForwardFailure=yes \
                  ${mkSSHOptions cfg.defaultSSHOptions} \
                  ${mkSSHOptions instance.extraSSHOptions}
              '';
            in "${command}/bin/${scriptName}";
          };
        };
      };
      mkServices = instances: attrValues (mapAttrs mkService instances);
    in lib.listToAttrs (mkServices cfg.instances);

    home.activation.ensureLingerEnabled = mkIf (builtins.length (attrValues cfg.instances) > 0)
      (hm.dag.entryBefore [ "writeBoundary" ] ''(
        if ! test -e /var/lib/systemd/linger/$USER; then
          _iError "Linger should be enabled, otherwise reverse proxy won't run on machine start without logging in this user!"
          $DRY_RUN_CMD exit 1
        fi
      )'');
  };
}
