{ hostName, config, lib, ... }: let
  envDir = "${config.xdg.configHome}/sshrp";
in {
  sops.secrets = {
    # 2x1080ti
    "sshrp/ssh-2x1080ti-via-winston-env" = lib.mkIf (hostName == "cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-winston-env";
    };
    "sshrp/ssh-2x1080ti-via-peterpan-env" = lib.mkIf (hostName == "cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-peterpan-env";
    };

    # shared
    "sshrp/ssh-shared-via-winston-env" = lib.mkIf (hostName == "cad-liu") {
      path = "${envDir}/ssh-shared-via-winston-env";
    };
    "sshrp/ssh-shared-via-peterpan-env" = lib.mkIf (hostName == "cad-liu") {
      path = "${envDir}/ssh-shared-via-peterpan-env";
    };

    # mono
    "sshrp/ssh-mono-via-winston-env" = lib.mkIf (hostName == "mono") {
      path = "${envDir}/ssh-mono-via-winston-env";
    };
    "sshrp/ssh-mono-via-peterpan-env" = lib.mkIf (hostName == "mono") {
      path = "${envDir}/ssh-mono-via-peterpan-env";
    };
  };

  services.ssh-reverse-proxy = let
    identityFile = config.sops.secrets."userKey/gy@${hostName}".path;
    _mkInstance = instanceName: extraOpts: {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/${instanceName}-env".path;
      } // extraOpts;
    mkInstances = instances: builtins.mapAttrs _mkInstance instances;
    cfgs = {
      cadliu = mkInstances {
        ssh-2x1080ti-via-winston = {
          bindPort = 13815;
          hostPort = 22222;
        };
        ssh-2x1080ti-via-peterpan = {
          bindPort = 10023;
          hostPort = 22222;
        };
      };
      cad-liu = mkInstances {
        ssh-shared-via-winston = {
          bindPort = 22548;
          hostPort = 22222;
        };
        ssh-shared-via-peterpan = {
          bindPort = 10025;
          hostPort = 22222;
        };
      };
      mono = mkInstances {
        ssh-mono-via-winston = {
          bindPort = 17266;
          hostPort = 22;
        };
        ssh-mono-via-peterpan = {
          bindPort = 20497;
          hostPort = 22;
        };
      };
    };
  in {
    instances = cfgs.${hostName} or {};
  };
}
