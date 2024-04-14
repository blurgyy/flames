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
          type = with types; nullOr (oneOf [ int str ]);
          default = null;
          description = ''
            Specify which port is exposed on the remote machine.  If missing, will try to use the
            BIND_PORT environment variable from `environmentFile`.
          '';
        };
        hostPort = mkOption {
          type = with types; nullOr (oneOf [ int str ]);
          default = null;
          description = ''
            Specify which port is connected to on the host machine, if missing, will try to use the
            HOST_PORT environment variable from `environmentFile`.
          '';
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
                  -NR "$BIND_ADDR:${
                      toString (if instance.bindPort != null then instance.bindPort else "$BIND_PORT")
                    }:localhost:${
                      toString (if instance.hostPort != null then instance.hostPort else "$HOST_PORT")
                    }" \
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

    home.activation.restartSopsNix = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''(
      if ${pkgs.systemd}/bin/systemctl --user list-unit-files | grep -q sops-nix.service; then
        echo "trying to restart sops-nix.service"
        $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user restart sops-nix.service
      fi
    )'';
  };
}
