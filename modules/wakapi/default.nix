{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.wakapi;
  portType = with types; oneOf [ str int ];
  serverOptions = types.submodule ({ ... }: {
    options = {
      addr = mkOption { type = types.str; description = "IPv4 address to listen on"; };
      port = mkOption { type = portType; };
      timeout = mkOption { type = types.int; default = 30; };
      basePath = mkOption { type = types.str; default = "/"; };
      publicUrl = mkOption { type = types.str; example = "https://example.org"; };
    };
  });
  appOptions = types.submodule ({ ... }: {
    options = {
      aggregationTime = mkOption {
        type = types.str;
        description = "Time at which to run daily aggregation batch jobs";
        default = "02:15";
      };
      reportTimeWeekly = mkOption {
        type = types.str;
        description = "Time at which to fan out weekly reports (format: '<weekday>,<daytime>')";
        default = "sat,23:59";
      };
      inactiveDays = mkOption {
        type = types.int;
        description = "Time of previous days within a user must have logged in to be considered active";
        default = 998244353;
      };
      importBatchSize = mkOption {
        type = types.int;
        description = "Maximum number of heartbeats to insert into the database within one transaction";
        default = 50;
      };
      customLanguages = mkOption { type = types.nullOr (types.attrsOf types.str); default = null; };
      avatarUrlTemplate = mkOption {
        type = types.str;
        default = "https://www.gravatar.com/avatar/{email_hash}";
      };
    };
  });
  securityOptions = types.submodule ({ ... }: {
    options = {
      passwordSalt = mkOption { type = with types; oneOf [ str int ]; };
      insecureCookies = mkOption { type = types.bool; default = false; };
      cookieMaxAge = mkOption { type = types.int; default = 172800; };
      allowSignup = mkOption { type = types.bool; default = true; };
      exposeMetrics = mkOption { type = types.bool; default = false; };
    };
  });
  smtpOptions = types.submodule ({ ... }: {
    options = {
      enable = mkEnableOption "Whether to enable mails (used for password resets, reports, etc.)";
      sender = mkOption { type = types.str; example = "Wakapi <notify@example.org>"; };
      host = mkOption { type = types.str; };
      port = mkOption { type = portType; };
      username = mkOption { type = types.str; };
      password = mkOption { type = types.str; };
      tls = mkOption { type = types.bool; };
    };
  });
in {
  options.services.wakapi = {
    enable = mkEnableOption "Enable coding statistics tracker via wakapi";
    server = mkOption { type = serverOptions; };
    app = mkOption { type = appOptions; default = {}; };
    dbFileName = mkOption { type = types.str; default = "db.sqlite"; };
    security = mkOption { type = securityOptions; };
    smtp = mkOption { type = types.nullOr smtpOptions; default = null; };
  };

  config = mkIf cfg.enable {
    users = {
      users.wakapi = {
        group = config.users.groups.wakapi.name;
        isSystemUser = true;
      };
      groups.wakapi = {};
    };
    sops.templates."wakapi.yaml" = {
      content = import ./config-content.nix { inherit cfg lib; };
      owner = config.users.users.wakapi.name;
      group = config.users.groups.wakapi.name;
    };
    systemd.services.wakapi = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = rec {
        User = config.users.users.wakapi.name;
        Group = config.users.groups.wakapi.name;
        WorkingDirectory = "/var/lib/${StateDirectory}";
        StateDirectory = "wakapi";
        ProtectSystem = "strict";
        StateDirectoryMode = "0700";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ExecStart = [
          "${pkgs.wakapi}/bin/wakapi -config ${config.sops.templates."wakapi.yaml".path}"
        ];
      };
    };
  };
}
