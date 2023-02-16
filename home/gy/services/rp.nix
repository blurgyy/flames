{ config, lib, name, helpers, ... }: let
  envDir = "${config.xdg.configHome}/sshrp";
in {
  sops.secrets = {
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
  in (if name == "gy@cadliu" then {
    ssh-2x1080ti-via-watson = {
      inherit identityFile;

      environmentFile = config.sops.secrets."sshrp/ssh-2x1080ti-via-watson-env".path;
      bindPort = 13815;
      hostPort = 22222;
      user = "gy";
    };
    ssh-2x1080ti-via-peterpan = {
      inherit identityFile;

      environmentFile = config.sops.secrets."sshrp/ssh-2x1080ti-via-peterpan-env".path;
      bindPort = 10023;
      hostPort = 22222;
    };
  } else if (name == "gy@cad-liu") then {
    ssh-shared-via-watson = {
      inherit identityFile;

      environmentFile = config.sops.secrets."sshrp/ssh-shared-via-watson-env".path;
      bindPort = 22548;
      hostPort = 22222;
      user = "gy";
    };
    ssh-shared-via-peterpan = {
      inherit identityFile;

      environmentFile = config.sops.secrets."sshrp/ssh-shared-via-peterpan-env".path;
      bindPort = 10025;
      hostPort = 22222;
    };
  } else {});
}
