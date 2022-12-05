{ config, pkgs, lib, ... }: {
  sops.secrets.btrbk-ssh-id = {
    owner = config.users.users.btrbk.name;
    group = config.users.groups.btrbk.name;
  };

  systemd.services = lib.mapAttrs' (name: _: {
    name = "btrbk-${name}";
    value = {
      path = with pkgs; [
        mbuffer  # required by stream_buffer
        zstd  # required by stream_compress
      ];
    };
  }) config.services.btrbk.instances;

  services.btrbk.instances = let
    globalCfg = {
      timestamp_format = "long-iso";
      preserve_day_of_week = "sunday";
      preserve_hour_of_day = "6";

      ssh_identity = config.sops.secrets.btrbk-ssh-id.path;

      stream_compress = "zstd";
      stream_buffer = "256m";
    };
  in {
    password-backup = {
      onCalendar = "00/8:00:00";  # Every 8 hours since midnight
      settings = globalCfg // {
        subvolume."ssh://cindy/var/lib/bitwarden_rs" = {
          target = "/elements/.btrbk/backups";  # this directory needs to be created manually
          snapshot_create = "ondemand";  # create if target is attached
          snapshot_dir = "/.btrbk/snapshots";  # run `sudo mkdir /.btrbk/snapshots -p` on the remote machine

          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "8w *m";
        };
      };
    };
    codingstats-backup = {
      onCalendar = "06:00:00 CST";  # morning 06:00 every day
      settings = globalCfg // {
        subvolume."ssh://cindy/var/lib/wakapi" = {
          target = "/elements/.btrbk/backups";
          snapshot_create = "ondemand";
          snapshot_dir = "/.btrbk/snapshots";

          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "8w";
        };
      };
    };
  };
}
