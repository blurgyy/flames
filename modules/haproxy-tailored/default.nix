{ config, pkgs, lib, ... }: with lib; let
  cfg = config.services.haproxy-tailored;
  acls = let
    aclModule = types.submodule ({ ... }: {
      options.name = mkOption { type = type.str; example = "begins_with_v2_or_api"; };
      options.body = mkOption { type = type.str; example = "path_beg /v2 || path_beg /api"; };
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
      inherit mode;
      inherit acls requestRules;
      server = mkOption { type = backendServerModule; };
    };
  });
  defaultsModule = types.submodule ({ ... }: {
    options = {
      inherit mode;
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
    frontends = mkOption { type = types.attrsOf frontendModule; default = []; };
    backends = mkOption { type = types.attrsOf backendModule; default = []; };
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
    services.haproxy = {
      enable = true;
      config = import ./config-content.nix { inherit lib cfg; };
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
        serviceConfig.ExecStartPre = mkBefore (concatLists (attrValues (mapAttrs
          (_: frontendConfig: let
            certRoot = if frontendConfig.domain.acme.enable
              then "/var/lib/acme"
              else "/var/lib/self-signed";
            domainName = frontendConfig.domain.name;
          in [
            "${pkgs.coreutils}/bin/mkdir -p /run/haproxy/${domainName}"
            # NOTE: use bash since systemd does not know how to treat redirection
            "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat ${certRoot}/${domainName}/cert.pem ${certRoot}/${domainName}/key.pem >/run/haproxy/${domainName}/full.pem'"
          ])
          (filterAttrs (_: frontendConfig: frontendConfig.domain != null) cfg.frontends)
        )));
        reloadTriggers = [
          (replaceStrings [ " " ] [ "" ]
            (concatStringsSep ""
              (splitString "\n" config.services.haproxy.config)
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
