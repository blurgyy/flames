{ config, pkgs, lib, ... }: let
  backupTargetDirectory = "/elements/.btrbk/backups";  # /elements should be mounted
in {
  sops.secrets.btrbk-ssh-id = {
    owner = config.users.users.btrbk.name;
    group = config.users.groups.btrbk.name;
  };

  systemd.tmpfiles.rules = [
    "d ${backupTargetDirectory} 0700 root root - -"
  ];

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
    subvolSharedCfg = {
      target = backupTargetDirectory;
      snapshot_create = "ondemand";  # create if target is attached.  REF: <https://digint.ch/btrbk/doc/btrbk.conf.5.html>
      snapshot_dir = "/.btrbk/snapshots";
    };
  in {
    password-backup = {
      onCalendar = "00/8:00:00";  # Every 8 hours since midnight
      settings = globalCfg // {
        subvolume."ssh://cindy/var/lib/bitwarden_rs" =  subvolSharedCfg //{
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
        subvolume."ssh://cindy/var/lib/wakapi" =  subvolSharedCfg //{
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "1w";
        };
      };
    };

    rssbot-backup = {
      onCalendar = "00:00:00 CST";  # morning 06:00 every day
      settings = globalCfg // {
        subvolume."ssh://cindy/var/lib/rssbot" = subvolSharedCfg // {
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "1w 1m";
        };
      };
    };

    mail-backup = {
      onCalendar = "08:00:00 CST";
      settings = globalCfg // {
        subvolume."ssh://rubik/var/spool/mail" = subvolSharedCfg // {
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "1w 6m *y";
        };
      };
    };

    repos-backup = {
      onCalendar = "04:00:00 CST";
      settings = globalCfg // {
        subvolume."ssh://peterpan/var/lib/soft-serve" = subvolSharedCfg // {
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";

          target_preserve_min = "latest";
          target_preserve = "1w 3m 2y";
        };
      };
    };

  };
}
