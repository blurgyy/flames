{ lib, cfg }: with lib; let
  mkFrontend = opts: ''
frontend ${opts.name}
  mode ${opts.mode}
  ${concatStringsSep "\n  " (map (opt: "option ${opt}") (opts.options))}
  ${concatStringsSep "\n  " (map
    (bind: "bind ${bind} ${optionalString opts.acceptProxy "accept-proxy"} ${optionalString (opts.domain != null)
      "ssl crt /run/haproxy/${opts.domain.name}/full.pem"
    } alpn ${concatStringsSep "," opts.alpns}")
    opts.binds
  )}
  ${concatStringsSep "\n  " (map (acl: "acl ${acl.name} ${acl.body}") opts.acls)}
  ${concatStringsSep "\n  " (map (rule: "${opts.mode}-request ${rule}") opts.requestRules)}
  ${concatStringsSep "\n  " (map
    (backend: "${if backend.isDefault then "default" else "use"}_backend ${backend.name}${optionalString (!backend.isDefault) " ${backend.condition}"}")
    opts.backends
  )}
'';
  mkBackend = opts: ''
backend ${opts.name}
  mode ${opts.mode}
  ${concatStringsSep "\n  " (map (opt: "option ${opt}") (opts.options))}
  ${concatStringsSep "\n  " (map (acl: "acl ${acl.name} ${acl.body}") opts.acls)}
  ${concatStringsSep "\n  " (map (rule: "${opts.mode}-request ${rule}") opts.requestRules)}
  server ${opts.name}-server ${opts.server.address} ${concatStringsSep " " opts.server.extraArgs}
'';
in ''
# This 2 lines are taken from the standard nixos module `services.haproxy`
global
  stats socket /run/haproxy/haproxy.sock mode 600 expose-fd listeners level user
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
  ${concatStringsSep "\n  " (map (opt: "option ${opt}") (cfg.defaults.options))}
  option dontlognull
  timeout connect ${cfg.defaults.timeout.connect}
  timeout client  ${cfg.defaults.timeout.client}
  timeout server  ${cfg.defaults.timeout.server}

# FRONTENDS ########################################################################################
${concatStringsSep "\n" (attrValues (mapAttrs (name: frontendConfig: mkFrontend (frontendConfig // { inherit name; })) cfg.frontends))}

# BACKENDS #########################################################################################
${concatStringsSep "\n" (attrValues (mapAttrs (name: backendConfig: mkBackend (backendConfig // { inherit name; })) cfg.backends))}
''
