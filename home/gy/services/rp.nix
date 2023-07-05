{ config, lib, name, helpers, ... }: let
  envDir = "${config.xdg.configHome}/sshrp";
in {
  sops.secrets = {
    # 2x1080ti
    "sshrp/ssh-2x1080ti-via-winston-env" = lib.mkIf (name == "gy@cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-winston-env";
    };
    "sshrp/ssh-2x1080ti-via-shared-env" = lib.mkIf (name == "gy@cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-shared-env";
    };
    "sshrp/ssh-2x1080ti-via-peterpan-env" = lib.mkIf (name == "gy@cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-peterpan-env";
    };

    # shared
    "sshrp/ssh-shared-via-winston-env" = lib.mkIf (name == "gy@cad-liu") {
      path = "${envDir}/ssh-shared-via-winston-env";
    };
    "sshrp/ssh-shared-via-peterpan-env" = lib.mkIf (name == "gy@cad-liu") {
      path = "${envDir}/ssh-shared-via-peterpan-env";
    };
  };

  services.ssh-reverse-proxy = let
    identityFile = config.sops.secrets."userKey/${name}".path;
    _mkInstance = instanceName: extraOpts: {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/${instanceName}-env".path;
      } // extraOpts;
    mkInstances = instances: builtins.mapAttrs _mkInstance instances;
    cfgs = {
      "gy@cadliu" = mkInstances {
        ssh-2x1080ti-via-winston = {
          bindPort = 13815;
          hostPort = 22222;
        };
        ssh-2x1080ti-via-shared = {
          bindPort = 31413;
          hostPort = 22222;
          user = "gy";
        };
        ssh-2x1080ti-via-peterpan = {
          bindPort = 10023;
          hostPort = 22222;
        };
      };
      "gy@cad-liu" = mkInstances {
        ssh-shared-via-winston = {
          bindPort = 22548;
          hostPort = 22222;
        };
        ssh-shared-via-peterpan = {
          bindPort = 10025;
          hostPort = 22222;
        };
      };
    };
  in {
    instances = cfgs.${name} or {};
  };
}
