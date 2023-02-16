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
        extraSSHOptions = mkOption { type = with types; attrsOf str; default = {}; };
      };
    });
  in {
    instances = mkOption {
      type = types.attrsOf hostInstanceModule;
      default = {};
    };
  };

  config = {
    systemd.user.services = let
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
                  -oUserKnownHostsFile=/dev/null \
                  -oUser=sshrp \
                  -oCompression=yes \
                  -oControlMaster=no \
                  -oServerAliveInterval=60 \
                  -oServerAliveCountMax=3 \
                  -oStrictHostKeyChecking=no \
                  -oIdentityFile=${instance.identityFile} \
                  ${lib.concatStringsSep " " (
                    with builtins;
                      attrValues
                        (mapAttrs
                          (k: v: "-o${k}=${v}")
                          instance.extraSSHOptions
                        )
                  )}
              '';
            in "${command}/bin/${scriptName}";
          };
        };
      };
      mkServices = instances: attrValues (mapAttrs mkService instances);
    in lib.listToAttrs (mkServices cfg.instances);

    home.activation.ensureLingerEnabled = mkIf (builtins.length (attrValues cfg.instances) > 0)
      (hm.dag.entryBefore [ "writeBoundary" ] ''(
        $DRY_RUN_CMD test -e /var/lib/systemd/linger/$USER || \
          _iError "Linger should be enabled, otherwise reverse proxy won't run on machine start without logging in this user!" && \
          exit 1
      )'');
  };
}
