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
      certFile = mkOption { type = types.nullOr types.str; default = null; };
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
  backendModule = types.submodule ({ ... }: {
    options = {
      name = mkOption { type = types.str; };
      inherit mode;
      inherit acls requestRules;
      server = mkOption { type = types.str; example = "127.0.0.1:8080"; };
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
    domain = mkOption { type = types.nullOr types.str; };
    acme = types.submodule ({ ... }: {
      options.enable = mkOption { type = types.bool; };
      options.group = mkOption { type = types.str; default = cfg.group; };
      options.webroot = mkOption { type = types.str; default = "/tmp/acme-challenge"; };
    });
    frontends = mkOption { type = types.listOf frontendModule; default = []; };
    backends = mkOption { type = types.listOf backendModule; default = []; };
  };

  config = let
    mkFrontend = opts: ''
frontend ${opts.name}
  mode ${opts.mode}
  ${concatStringsSep "\n  " (map
    (bind: "bind ${bind} ${optionalString opts.acceptProxy "accept-proxy"} ${optionalString (opts.certFile != null) "ssl crt ${opts.certFile}"} alpn ${concatStringsSep "," opts.alpns}")
    opts.binds
  )}
  ${concatStringsSep "\n  " (map (acl: "acl ${acl.name} ${acl.body}") opts.acls)}
  ${concatStringsSep "\n  " (map (rule: "${opts.mode}-request ${rule}") opts.requestRules)}
  ${concatStringsSep "\n  " (map
    (backend: "${if backend.isDefault then "default" else "use"}_backend ${backend.name}${optionalString (!backends.isDefault) " ${backend.condition}"}")
    opts.backends
  )}
'';
    mkBackend = opts: ''
backend ${opts.name}
  mode ${opts.mode}
  ${concatStringsSep "\n  " (map (acl: "acl ${acl.name} ${acl.body}") opts.acls)}
  ${concatStringsSep "\n  " (map (rule: "${opts.mode}-request ${rule}") opts.requestRules)}
  server ${opts.name}-server ${opts.server}
'';
  in mkIf cfg.enable {
    services.haproxy = {
      enable = true;
      config = ''
## This 2 lines are already defined in module `services.haproxy`
#global
#  stats socket /run/haproxy/haproxy.sock mode 600 expose-fd listeners level user
  log stdout local0 info
  stats timeout 30s
  user ${cfg.user}
  group ${cfg.group}
  daemon
  ca-base /etc/ssl/certs

  # REF: <https://weakdh.org/sysadmin.html#haproxy>
  ssl-default-bind-ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
  ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11

  tune.ssl.default-dh-param 2048

defaults
  log global
  option dontlognull
  mode ${cfg.defaults.mode}
  timeout connect ${cfg.defaults.timeout.connect}
  timeout client  ${cfg.defaults.timeout.client}
  timeout server  ${cfg.defaults.timeout.server}

# FRONTENDS ########################################################################################
${concatStringsSep "\n" (map mkFrontend cfg.frontends)}

# BACKENDS #########################################################################################
${concatStringsSep "\n" (map mkBackend cfg.backends)}
      '';
    };
  };
}
