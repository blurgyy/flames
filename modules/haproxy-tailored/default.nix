{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.haproxy-tailored;
  acls = let
    aclModule = types.submodule ({ ... }: {
      options.name = mkOption { type = types.str; example = "begins_with_v2_or_api"; };
      options.body = mkOption { type = types.str; example = "path_beg /v2 || path_beg /api"; };
    });
  in mkOption { type = types.listOf aclModule; default = []; };
  requestRules = mkOption {
    type = types.listOf types.str;
    description = ''
      Specifies how to respond to requests.  Adds to `tcp-request` entries if mode is `tcp`,
      adds to `http-request` entries if mode is `http`.
    '';
    example = [ "redirect scheme https code 301 unless { ssl_fc }" ];
    default = [];
  };
  timeoutModule = types.submodule ({ ... }: {
    options.connect = mkOption { type = types.str; default = "5s"; };
    options.client = mkOption { type = types.str; default = "300s"; };
    options.server = mkOption { type = types.str; default = "300s"; };
  });
  mode = mkOption { type = types.enum [ "tcp" "http" ]; default = "tcp"; };
  acmeModule = types.submodule ({ ... }: {
    options.enable = mkEnableOption "Whether to enable Let's Encrypt certificate issuing via ACME";
    options.email = mkOption { type = types.nullOr types.str; default = null; };
    options.credentialsFile = mkOption { type = types.nullOr types.path; default = null; };
  });
  domainModule = types.submodule ({ ... }: {
    options.name = mkOption { type = types.str; };
    options.extraNames = mkOption { type = types.listOf types.str; default = []; };
    options.reloadServices = mkOption { type = types.listOf types.str; default = []; };
    options.acme = mkOption { type = acmeModule; };
  });
  frontendModule = types.submodule ({ ... }: {
    options = {
      name = mkOption { type = types.str; };
      inherit mode;
      options = mkOption { type = types.listOf types.str; default = []; };
      binds = mkOption {
        type = types.listOf types.str;
        example = [ "*:80" "0.0.0.0:8080" "127.0.0.1:10000-10086" "abns@/haproxy/server.sock" ];
      };
      alpns = mkOption {
        type = types.listOf (types.enum [ "http/1.1" "h2" ]);
        default = [ "http/1.1" ];
      };
      acceptProxy = mkOption { type = types.bool; default = false; };
      domain = mkOption { type = types.nullOr domainModule; default = null; };
      inherit acls requestRules;
      backends = let
        useBackendModule = types.submodule ({ ... }: {
          options.name = mkOption { type = types.str; };
          options.isDefault = mkOption { type = types.bool; default = false; };
          options.condition = mkOption { type = types.str; example = "if !HTTP"; };
        });
      in mkOption { type = types.listOf useBackendModule; default = []; };
    };
  });
  backendModule = types.submodule ({ ... }: let
    backendServerModule = types.submodule ({ ... }: {
      options.address = mkOption { type = types.str; example = "127.0.0.1:8080"; };
      options.extraArgs = mkOption {
        type = types.listOf types.str;
        example = [ "send-proxy-v2" ];
        default = [];
      };
    });
  in {
    options = {
      name = mkOption { type = types.str; };
      options = mkOption { type = types.listOf types.str; default = []; };
      inherit mode;
      inherit acls requestRules;
      server = mkOption { type = backendServerModule; };
    };
  });
  defaultsModule = types.submodule ({ ... }: {
    options = {
      inherit mode;
      options = mkOption { type = types.listOf types.str; default = [ "dontlognull" ]; };
      timeout = mkOption {
        type = timeoutModule;
        default = { connect = "5s"; client = "300s"; server = "300s"; };
      };
    };
  });
in {
  options.services.haproxy-tailored = {
    enable = mkEnableOption "Tailored HAProxy service";
    package = mkOption { type = types.package; default = pkgs.haproxy; };
    defaults = mkOption {
      type = defaultsModule;
      default = { timeout = { connect = "5s"; client = "300s"; server = "300s"; }; mode = "tcp"; };
    };
    user = mkOption { type = types.str; default = "haproxy"; };
    group = mkOption { type = types.str; default = "haproxy"; };
    frontends = mkOption { type = types.nullOr (types.attrsOf frontendModule); default = null; };
    backends = mkOption { type = types.nullOr (types.attrsOf backendModule); default = null; };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = builtins.all
        (svc: trace svc (hasSuffix ".service" svc))
        (concatLists (attrValues (mapAttrs
          (_: frontendConfig: frontendConfig.domain.reloadServices)
          (filterAttrs
            (_: frontendConfig: frontendConfig.domain != null)
            cfg.frontends
          )
        )));
      message = ''
        Service names in `services.haproxy-tailored.frontends.<name>.domain.reloadServices` must end
        with ".service"
      '';
    }];
    services.haproxy-tailored.defaults.options = [ "dontlognull" ];
    services.haproxy.enable = false;
    users = {
      users.haproxy = {
        group = config.users.groups.haproxy.name;
        isSystemUser = true;
      };
      groups.haproxy = {};
    };
    sops.templates.haproxy-cfg = {
      content = import ./config-content.nix { inherit lib cfg; };
      owner = config.users.users.haproxy.name;
      group = config.users.groups.haproxy.name;
    };
    security.acme = {
      acceptTerms = true;
      certs = let
        acmePairs = attrValues (mapAttrs (_: frontendConfig: let
          hasRoot = frontendConfig.acmeRoot != null;
        in nameValuePair frontendConfig.domain.name {
          group = mkDefault cfg.group;
          dnsProvider = "cloudflare";
          extraDomainNames = frontendConfig.domain.extraNames;
          inherit (frontendConfig.domain.acme) email credentialsFile;
          reloadServices = unique ([ "haproxy.service" ] ++ frontendConfig.domain.reloadServices);
        }) (filterAttrs (_: frontendConfig: frontendConfig.domain != null && frontendConfig.domain.acme.enable) cfg.frontends));
      in listToAttrs acmePairs;
    };
    systemd.services = {
      haproxy = {
        serviceConfig = {
          User = config.users.users.haproxy.name;
          Group = config.users.groups.haproxy.name;
          Type = "notify";
          ExecStartPre = (concatLists (attrValues (mapAttrs
            (_: frontendConfig: let
              certRoot = if frontendConfig.domain.acme.enable
                then "/var/lib/acme"
                else "/var/lib/self-signed";
              domainName = frontendConfig.domain.name;
            in [
              "${pkgs.coreutils}/bin/mkdir -p /run/haproxy/${domainName}"
              # HACK: wait for certificate and key files to be generated up to 3 seconds
              "${pkgs.bash}/bin/bash -c 'for i in 1 2 3; do if [[ -e ${certRoot}/${domainName}/cert.pem ]] && [[ -e ${certRoot}/${domainName}/key.pem ]]; then echo certificate and key files are found; break; else sleep 1; echo waiting for certificate and key files \"(retry $i/3)\"; fi; done'"
              # NOTE: use bash since systemd does not know how to treat redirection
              "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat ${certRoot}/${domainName}/cert.pem ${certRoot}/${domainName}/key.pem >/run/haproxy/${domainName}/full.pem'"
            ])
            (filterAttrs (_: frontendConfig: frontendConfig.domain != null) cfg.frontends)
          ))) ++ [
            # when the master process receives USR2, it reloads itself using exec(argv[0]),
            # so we create a symlink there and update it before reloading
            "${pkgs.coreutils}/bin/ln -sf ${pkgs.haproxy}/sbin/haproxy /run/haproxy/haproxy"
            # when running the config test, don't be quiet so we can see what goes wrong
            "/run/haproxy/haproxy -c -f ${config.sops.templates.haproxy-cfg.path}"
          ];
          ExecStart = "/run/haproxy/haproxy -Ws -f ${config.sops.templates.haproxy-cfg.path} -p /run/haproxy/haproxy.pid";
          # support reloading
          ExecReload = [
            "${pkgs.haproxy}/sbin/haproxy -c -f ${config.sops.templates.haproxy-cfg.path}"
            "${pkgs.coreutils}/bin/ln -sf ${pkgs.haproxy}/sbin/haproxy /run/haproxy/haproxy"
            "${pkgs.coreutils}/bin/kill -USR2 $MAINPID"
          ];
          KillMode = "mixed";
          SuccessExitStatus = "143";
          Restart = "always";
          RuntimeDirectory = "haproxy";
          # upstream hardening options
          NoNewPrivileges = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          SystemCallFilter= "~@cpu-emulation @keyring @module @obsolete @raw-io @reboot @swap @sync";
          # needed in case we bind to port < 1024
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        };
        reloadTriggers = [
          (replaceStrings [ " " ] [ "" ]
            (concatStringsSep ""
              (splitString "\n" config.sops.templates.haproxy-cfg.content)
            )
          )
        ];
      };
    } // (let
      commonServiceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = mkDefault cfg.group;
        UMask = 0022;
        StateDirectoryMode = 750;
        ProtectSystem = "strict";
        ReadWritePaths = [
          "/var/lib/self-signed"
        ];
        PrivateTmp = true;

        WorkingDirectory = "/tmp";

        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          # 1. allow a reasonable set of syscalls
          "@system-service"
          # 2. and deny unreasonable ones
          "~@privileged @resources"
          # 3. then allow the required subset within denied groups
          "@chown"
        ];
      };
      createServiceFor = domain: nameValuePair "self-sign-${domain.name}" {
        description = "Generate self-signed certificate for ${domain.name}";
        before = unique ([ "haproxy.service" ] ++ domain.reloadServices);
        wantedBy = [ "multi-user.target" ];
        serviceConfig = commonServiceConfig // {
          StateDirectory = "self-signed/${domain.name}";
          BindPaths = [
            "/var/lib/self-signed/${domain.name}:/tmp/${domain.name}"
          ];
          ExecStartPost = [
            "+systemctl --no-block try-reload-or-restart haproxy.service ${
              concatStringsSep " " domain.reloadServices
            }"
          ];
        };
        script = ''
          rm -rf ${domain.name}/*
          mkdir -p ca
          ${pkgs.minica}/bin/minica \
            --ca-key ca/key.pem \
            --ca-cert ca/cert.pem \
            --domains ${escapeShellArg domain.name}
          # Create files to match directory layout for real certificates
          cd '${domain.name}'
          cp ../ca/cert.pem chain.pem
          cat cert.pem chain.pem > fullchain.pem
          cat key.pem fullchain.pem > full.pem
          # Group might change between runs, re-apply it
          chown '${cfg.user}:${cfg.group}' *
          # Default permissions make the files unreadable by group + anon
          # Need to be readable by group
          chmod 640 *
        '';
      };
    in listToAttrs (attrValues (mapAttrs
      (_: frontendConfig: createServiceFor frontendConfig.domain)
      (filterAttrs
        (_: frontendConfig: frontendConfig.domain != null && (!frontendConfig.domain.acme.enable))
        cfg.frontends
      )))
    );
    systemd.timers = let
      createTimerFor = domain: nameValuePair "self-sign-${domain.name}" {
        description = "Renew self-signed certificate for ${domain.name}";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Unit = "self-sign-${domain.name}.service";
          Persistent = "yes";
          RandomizedDelaySec = "24h";
        };
      };
    in listToAttrs (attrValues (mapAttrs
      (_: frontendConfig: createTimerFor frontendConfig.domain)
      (filterAttrs
        (_: frontendConfig: frontendConfig.domain != null && (!frontendConfig.domain.acme.enable))
        cfg.frontends
      )
    ));
  };
}
