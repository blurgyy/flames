{ config, lib, name, helpers, ... }: {
  sops.secrets = {
    "sshrp/ssh-2x1080ti-via-watson-env" = lib.mkIf (name == "gy@cadliu") {};
    "sshrp/ssh-shared-via-watson-env" = lib.mkIf (name == "gy@cad-liu") {};
  };

  services.ssh-reverse-proxy.instances = (if name == "gy@cadliu" then {
    ssh-2x1080ti-via-watson = {
      environmentFile = config.sops.secrets."sshrp/ssh-2x1080ti-via-watson-env".path;
      identityFile = config.sops.secrets."userKey/${name}".path;
      bindPort = 13815;
      hostPort = 22222;
    };
  } else if (name == "gy@cad-liu") then {
    ssh-shared-via-watson = {
      environmentFile = config.sops.secrets."sshrp/ssh-shared-via-watson-env".path;
      identityFile = config.sops.secrets."userKey/${name}".path;
      bindPort = 22548;
      hostPort = 22222;
    };
  } else {});
}
