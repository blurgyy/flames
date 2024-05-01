{ config, pkgs, lib, ... }:

{
  sops.secrets = let
    secretConfig.sopsFile = ../../../../_secrets.yaml;
  in {
    "api/r2/rclone-nixos/access_key_id" = secretConfig;
    "api/r2/rclone-nixos/secret_access_key" = secretConfig;
    "api/r2/account_id" = secretConfig;
  };

  sops.templates.rclone-r2-cfg = {
    name = "rclone-r2.conf";
    mode = "440";
    content = ''
      [r2]
      type = s3
      provider = Cloudflare
      access_key_id = ${config.sops.placeholder."api/r2/rclone-nixos/access_key_id"}
      secret_access_key = ${config.sops.placeholder."api/r2/rclone-nixos/secret_access_key"}
      endpoint = https://${config.sops.placeholder."api/r2/account_id"}${lib.optionalString
        (false  # the "eu" endpoint does not mount anything?
        && lib.hasPrefix "Europe" config.time.timeZone)
        ".eu"
      }.r2.cloudflarestorage.com
      acl = private
    '';
  };

  systemd.services.rclone-r2 = {
    after = [ "network.target" ]
      ++ lib.optional config.services.sing-box.enable "sing-box.service";
    wantedBy = [ "multi-user.target" ];
    script = ''
      mkdir -p r2
      chmod 770 r2
      ${pkgs.rclone}/bin/rclone \
        --config ${config.sops.templates.rclone-r2-cfg.path} \
        mount r2:/ ./r2 \
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
