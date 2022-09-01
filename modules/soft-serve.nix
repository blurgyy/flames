{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.soft-serve;
  portType = with types; oneOf [ str int ];
in {
  options.services.soft-serve = let
    bindModule = types.submodule ({ ... }: {
      options.addr = mkOption { type = types.str; default = "0.0.0.0"; };
      options.port = mkOption { type = portType; default = 77; };
    });
    displayModule = types.submodule ({ ... }: {
      options.name = mkOption { type = types.str; default = "Soft Serve"; };
      options.host = mkOption { type = types.str; description = "Address to use in public clone URLs"; example = "some.domain.org"; };
      options.port = mkOption { type = portType; default = cfg.bind.port; };
    });
    repoModule = types.submodule ({ ... }: {
      options.displayName = mkOption { type = types.str; description = "Name of repo displayed on TUI"; };
      options.directoryName = mkOption { type = types.str; };
      options.private = mkOption { type = types.bool; };
      options.note = mkOption { type = types.str; default = ""; };
      options.readme = mkOption { type = types.str; default = "README.md"; };
    });
    userModule = types.submodule ({ ... }: {
      options.name = mkOption { type = types.str; };
      options.isAdmin = mkOption { type = types.bool; };
      options.publicKeys = mkOption { type = types.listOf types.str; };
      options.collabRepos = mkOption { type = types.listOf types.str; default = []; };
    });
  in {
    enable = mkEnableOption "Enable soft-serve, a tasty, self-hostable Git server for the command line.";
    bind = mkOption { type = bindModule; };
    display = mkOption { type = displayModule; description = "Information to be displayed in the TUI"; };
    keyFile = mkOption {
      type = types.str;
      description = ''
        A path to soft-serve's root directory, specifies git server's host key file.  Path is
        an absolute path if it contains a leading slash, otherwise it's relative to soft-serve's
        root directory.  Key pair will be created if non was present.
      '';
      default = ".ssh/soft_serve_server_ed25519";
    };
    repoDirectory = mkOption {
      type = types.str;
      description = ''
        Specifies directory to store all repositories.  Path is an absolute path if it contains
        a leading slash, otherwise it's relative to soft-serve's root directory.
      '';
      default = ".repo";
    };
    anonAccess = mkOption {
      type = types.enum [ "admin-access" "read-write" "read-only" "no-access" ];
      default = "no-access";
    };
    allowKeyless = mkOption { type = types.bool; default = false; };
    repos = mkOption { type = types.listOf repoModule; default = []; };
    users = mkOption { type = types.nullOr (types.attrsOf userModule); default = null; };
  };

  config = mkIf cfg.enable {
    assertions = mkIf (cfg.users != null) [{
      assertion = builtins.any (user: user.isAdmin) (attrValues cfg.users);
      message = "At least one user should be set as admin for services.soft-serve";
    }];
    users = {
      users.softserve = {
        group = config.users.groups.softserve.name;
        isSystemUser = true;
      };
      groups.softserve = {};
    };
    systemd.services.soft-serve = let
      boolToString = val: if val then "true" else "false";
      softserveCfg = pkgs.writeText "config.yaml" ''
        # Generated, do not edit
        name: ${cfg.display.name}
        host: ${cfg.display.host}
        port: ${toString cfg.display.port}
        anon-access: ${cfg.anonAccess}
        allow-keyless: ${boolToString cfg.allowKeyless}
        repos:
          ${concatStringsSep "\n" (map (repo: ''
        # Placeholder comment, to prevent leading whitespaces from being stripped by nix
          - name: ${repo.displayName}
            repo: ${repo.directoryName}
            private: ${boolToString repo.private}
            note: ${repo.note}
            readme: ${repo.readme}
          '') cfg.repos)}
        users:
          ${optionalString (cfg.users != null) (concatStringsSep "\n" (attrValues (mapAttrs (username: user: ''
        # Placeholder comment, to prevent leading whitespaces from being stripped by nix
          - name: ${username}
            admin: ${boolToString user.isAdmin}
            public-keys:
              ${concatStringsSep "\n      " (map (key: "- ${key}") user.publicKeys)}
            collab-repos:
              ${concatStringsSep "\n      " (map (repo: "- ${repo}") user.collabRepos)}
          '') cfg.users)))}
      '';
      config-setup = with pkgs; writeShellScriptBin "soft-serve-config-setup" ''
        set -Eeuo pipefail

        export PATH=''${PATH:+${git}/bin:''${PATH}}
        export GIT_AUTHOR_NAME='softserve'
        export GIT_AUTHOR_EMAIL='softserve@${config.networking.hostName}'
        export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
        export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

        cd /tmp/soft-serve  # This is set in the BindPaths= directive
        cfgdir=$(realpath $(mktemp -d config-XXXXXXXX))  # Write configured values into cfgdir
        repodir=$(realpath ${cfg.repoDirectory})  # use absolute path to refer to repodir
        trap 'rm -rf "$cfgdir"' EXIT

        rm -rf "$repodir"/config  # Remove the bare config repo
        git init --bare --initial-branch=main "$repodir"/config
        git init --initial-branch=main "$cfgdir" && cd "$cfgdir"
        git remote add soft "$repodir"/config

        cp ${softserveCfg} config.yaml
        cat >README.md <<'EOF'
        # ${cfg.display.name}
        
        To create a new repo with name $repoName:

        ```
        git init $repoName && cd $repoName
        git remote add soft ssh://{{.Host}}:{{.Port}}/$repoName
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
      environment = {
        SOFT_SERVE_PORT = toString cfg.bind.port;
        SOFT_SERVE_BIND_ADDRESS = cfg.bind.addr;
        SOFT_SERVE_KEY_PATH = cfg.keyFile;
        SOFT_SERVE_REPO_PATH = cfg.repoDirectory;
      };
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
        ExecStartPre = [ "${config-setup}/bin/soft-serve-config-setup" ];
        ExecStart = "${pkgs.soft-serve}/bin/soft serve";
      };
    };
  };
}
