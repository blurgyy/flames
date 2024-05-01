{ config, pkgs, lib, ... }:

{
  sops.secrets = let
    secretConfig.sopsFile = ../../../../_secrets.yaml;
  in {
    "api/gdrive/rclone-nixos/client_id" = secretConfig;
    "api/gdrive/rclone-nixos/client_secret" = secretConfig;
    "api/gdrive/rclone-nixos/token" = secretConfig;
  };

  sops.templates.rclone-gdrive-cfg = {
    name = "rclone-gdrive.conf";
    mode = "440";
    content = ''
      [gdrive]
      type = drive
      scope = drive
      client_id = ${config.sops.placeholder."api/gdrive/rclone-nixos/client_id"}
      client_secret = ${config.sops.placeholder."api/gdrive/rclone-nixos/client_secret"}
      token = ${config.sops.placeholder."api/gdrive/rclone-nixos/token"}
    '';
  };

  systemd.services.rclone-gdrive = {
    after = [ "network.target" ]
      ++ lib.optional config.services.sing-box.enable "sing-box.service";
    wantedBy = [ "multi-user.target" ];
    script = ''
      mkdir -p gdrive
      chmod 770 gdrive
      ${pkgs.rclone}/bin/rclone \
        --config ${config.sops.templates.rclone-gdrive-cfg.path} \
        mount gdrive:/ ./gdrive \
        --allow-other
    '';
    serviceConfig = {
      WorkingDirectory = "/run/rclone";
      RuntimeDirectory = "rclone";
      RuntimeDirectoryMode = 770;
      Group = config.users.groups.rclone.name;
    };
  };
}
