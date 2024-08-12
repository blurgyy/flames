{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.soft-serve-tailored;
  portType = with types; oneOf [ str int ];
in {
  options.services.soft-serve-tailored = let
    bindModule = types.submodule ({ ... }: {
      options.sshAddr = mkOption { type = types.str; default = "0.0.0.0"; };
      options.sshPort = mkOption { type = portType; default = 77; };

      options.gitAddr = mkOption { type = types.str; default = "0.0.0.0"; };
      options.gitPort = mkOption { type = portType; default = 76; };

      options.httpAddr = mkOption { type = types.str; default = "0.0.0.0"; };
      options.httpPort = mkOption { type = portType; default = 75; };

      options.statsAddr = mkOption { type = types.str; default = "0.0.0.0"; };
      options.statsPort = mkOption { type = portType; default = 74; };
    });
    displayModule = types.submodule ({ ... }: {
      options.name = mkOption { type = types.str; default = "Soft Serve"; };
      options.host = mkOption { type = types.str; description = "Address to use in public clone URLs"; example = "some.domain.org"; };
      options.sshPort = mkOption { type = portType; default = cfg.bind.sshPort; };
      options.httpPort = mkOption { type = portType; default = cfg.bind.httpPort; };
    });
  in {
    enable = mkEnableOption "Enable soft-serve, a tasty, self-hostable Git server for the command line.";
    package = mkOption {
      type = types.package;
      default = pkgs.soft-serve;
    };
    bind = mkOption { type = bindModule; default = {}; };
    display = mkOption { type = displayModule; description = "Information to be displayed in the TUI"; };
    hostKey = mkOption {
      type = types.str;
      description = ''
        Specifies git server's host key file.  Path is an absolute path if it contains a leading
        slash, otherwise it's relative to soft-serve's working directory.  Key pair will be created
        if non was present.
      '';
      default = "ssh/soft_serve_server_ed25519";
    };
    clientKey = mkOption {
      type = types.str;
      description = ''
        Specifies git server's client key file, soft will use this as its identity while performing
        git operations (in hooks, etc.).  Path is an absolute path if it contains a leading slash,
        otherwise it's relative to soft-serve's working directory.  Key pair will be created if non
        was present.
      '';
      default = "ssh/soft_serve_client_ed25519";
    };
    dataDirectory = mkOption {
      type = types.str;
      description = ''
        Specifies the parent directory that holds all Soft Serve data and repositories.  Path is an
        absolute path if it contains a leading slash, otherwise it's relative to soft-serve's root
        directory.
      '';
      default = ".";
    };
    adminPublicKeys = mkOption { type = with types; listOf str; };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = (builtins.stringLength cfg.dataDirectory) > 0;
      message = "`services.soft-serve.dataDirectory` must be an non-empty string";
    }];
    environment.systemPackages = [ cfg.package ];
    users = {
      users.softserve = {
        group = config.users.groups.softserve.name;
        isSystemUser = true;
      };
      groups.softserve = {};
    };
    systemd.services.soft-serve = let
      softserveCfg = pkgs.writeText "config.yaml" ''
        # Soft Serve Server configurations

        # The name of the server.
        # This is the name that will be displayed in the UI.
        name: "${cfg.display.name}"

        # Logging configuration.
        log:
          # Log format to use. Valid values are "json", "logfmt", and "text".
          format: "text"
          # Time format for the log "timestamp" field.
          # Should be described in Golang's time format.
          time_format: "2006-01-02 15:04:05"

        # The SSH server configuration.
        ssh:
          # The address on which the SSH server will listen.
          listen_addr: "${cfg.bind.sshAddr}:${toString cfg.bind.sshPort}"

          # The public URL of the SSH server.
          # This is the address that will be used to clone repositories.
          public_url: "ssh://${cfg.display.host}:${toString cfg.display.sshPort}"

          # The path to the SSH server's private key.
          key_path: "${cfg.hostKey}"

          # The path to the server's client private key. This key will be used to
          # authenticate the server to make git requests to ssh remotes.
          client_key_path: "${cfg.clientKey}"

          # The maximum number of seconds a connection can take.
          # A value of 0 means no timeout.
          max_timeout: 0

          # The number of seconds a connection can be idle before it is closed.
          # A value of 0 means no timeout.
          idle_timeout: 0

        # The Git daemon configuration.
        git:
          # The address on which the Git daemon will listen.
          listen_addr: "${cfg.bind.gitAddr}:${toString cfg.bind.gitPort}"

          # The maximum number of seconds a connection can take.
          # A value of 0 means no timeout.
          max_timeout: 0

          # The number of seconds a connection can be idle before it is closed.
          idle_timeout: 3

          # The maximum number of concurrent connections.
          max_connections: 32

        # The HTTP server configuration.
        http:
          # The address on which the HTTP server will listen.
          listen_addr: "${cfg.bind.httpAddr}:${toString cfg.bind.httpPort}"

          # The path to the TLS private key.
          tls_key_path: ""

          # The path to the TLS certificate.
          tls_cert_path: ""

          # The public URL of the HTTP server.
          # This is the address that will be used to clone repositories.
          # Make sure to use https:// if you are using TLS.
          public_url: "http://${cfg.display.host}:${toString cfg.display.httpPort}"

        # The stats server configuration.
        stats:
          # The address on which the stats server will listen.
          listen_addr: "${cfg.bind.statsAddr}:${toString cfg.bind.statsPort}"

        # Additional admin keys.
        initial_admin_keys:
          ${concatStringsSep "\n      " (map (key: "- ${key}") cfg.adminPublicKeys)}
      '';
      home-repo-setup = pkgs.writeShellScript "home-repo-setup" ''
        set -Eeuo pipefail

        export PATH=''${PATH:+${pkgs.git}/bin:''${PATH}}
        export GIT_AUTHOR_NAME='softserve'
        export GIT_AUTHOR_EMAIL='softserve@${config.networking.hostName}'
        export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
        export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

        cd /tmp/soft-serve  # This is set in the BindPaths= directive
        cfgdir="$(realpath $(mktemp -d config-XXXXXXXX))"  # Write configured values into cfgdir
        datadir="$(realpath ${cfg.dataDirectory})"  # use absolute path to refer to datadir
        therepo="$datadir/repos/.soft-serve.git"
        trap 'rm -rf "$cfgdir"' EXIT

        rm -rf "$therepo"  # Remove the bare config repo
        git init --bare --initial-branch=main "$therepo"
        git init --initial-branch=main "$cfgdir" && cd "$cfgdir"
        git remote add soft "$therepo"

        cat >README.md <<'EOF'
          # ${cfg.display.name}

          To create a new repo with name $repoName:

          ```
          git init "$repoName" && cd "$repoName"
          git remote add soft ssh://${cfg.display.host}:${toString cfg.display.sshPort}/"$repoName"
          git push soft main
          ```
        EOF
        git add -A
        git commit -m "chore: initialize soft-serve config (done from nix module soft-serve)"
        git push soft main
      '';
    in {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.SOFT_SERVE_DATA_PATH = cfg.dataDirectory;
      path = [
        pkgs.bash
        # WARN: `soft` creates hooks with hard-coded absolute paths by default, that is not what we
        # want when the absolute path is inside the nix store as it eventually gets garbage
        # collected.
        cfg.package
      ];
      serviceConfig = rec {
        User = config.users.users.softserve.name;
        Group = config.users.groups.softserve.name;
        WorkingDirectory = "/var/lib/${StateDirectory}";
        StateDirectory = "soft-serve";
        StateDirectoryMode = "0700";
        NoNewPrivileges = true;
        PrivateTmp = true;
        BindPaths = [ "/var/lib/${StateDirectory}:/tmp/soft-serve" ];
        ProtectSystem = "strict";
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        ExecStartPre = [
          "${pkgs.coreutils-full}/bin/cp -vf \"${softserveCfg}\" \"${cfg.dataDirectory}/config.yaml\""
          "${home-repo-setup}"
        ];
        ExecStart = "${cfg.package}/bin/soft serve";
      };
    };
  };
}
