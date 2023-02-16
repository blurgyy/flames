{ config, lib, name, helpers, ... }: let
  envDir = "${config.xdg.configHome}/sshrp";
in {
  sops.secrets = {
    "sshrp/ssh-watson-env" = lib.mkIf (name == "gy@watson") {
      path = "${envDir}/ssh-watson-via-peterpan-env";
    };
    "sshrp/coderp-watson-env" = lib.mkIf (name == "gy@watson") {
      path = "${envDir}/coderp-watson-via-peterpan-env";
    };

    "sshrp/ssh-2x1080ti-via-watson-env" = lib.mkIf (name == "gy@cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-watson-env";
    };
    "sshrp/ssh-shared-via-watson-env" = lib.mkIf (name == "gy@cad-liu") {
      path = "${envDir}/ssh-shared-via-watson-env";
    };

    "sshrp/ssh-2x1080ti-via-peterpan-env" = lib.mkIf (name == "gy@cadliu") {
      path = "${envDir}/ssh-2x1080ti-via-peterpan-env";
    };
    "sshrp/ssh-shared-via-peterpan-env" = lib.mkIf (name == "gy@cad-liu") {
      path = "${envDir}/ssh-shared-via-peterpan-env";
    };
  };

  services.ssh-reverse-proxy.instances = let
    identityFile = config.sops.secrets."userKey/${name}".path;
    cfgs = let
      _mkInstance = instanceName: extraOpts: {
        inherit identityFile;
        environmentFile = config.sops.secrets."sshrp/${instanceName}-env".path;
      } // extraOpts;
      mkInstances = instances: builtins.mapAttrs _mkInstance instances;
    in {
      "gy@watson" = mkInstances {
        ssh-watson = {
          bindPort = 10020;
          hostPort = 22222;
        };
        coderp-watson = {
          bindPort = 1111;
          hostPort = 22222;
        };
      };
      "gy@cadliu" = mkInstances {
        ssh-2x1080ti-via-watson = {
          bindPort = 13815;
          hostPort = 22222;
          user = "gy";
        };
        ssh-2x1080ti-via-peterpan = {
          bindPort = 10023;
          hostPort = 22222;
        };
      };
      "gy@cad-liu" = mkInstances {
        ssh-shared-via-watson = {
          bindPort = 22548;
          hostPort = 22222;
          user = "gy";
        };
        ssh-shared-via-peterpan = {
          bindPort = 10025;
          hostPort = 22222;
        };
      };
    };
  in cfgs.${name} or {};
}
