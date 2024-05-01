{ config, pkgs, ... }:

{
  imports = [
    ./gdrive.nix
    ./r2.nix
  ];

  users = {
    users = {
      rclone = {
        isSystemUser = true;
        group = config.users.groups.rclone.name;
      };
      gy.extraGroups = [ config.users.groups.rclone.name ];
    };
    groups.rclone = {};
  };

  environment.systemPackages = [ pkgs.rclone ];
}
