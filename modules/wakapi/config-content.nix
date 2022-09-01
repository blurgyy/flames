{ cfg, lib }: with lib; let
  boolToString = val: if val then "true" else "false";
in ''
env: production

server:
  listen_ipv4: ${cfg.server.addr}               # leave blank to disable ipv4
  listen_ipv6:                                  # leave blank to disable ipv6
  listen_socket:                                # leave blank to disable unix sockets
  timeout_sec: ${toString cfg.server.timeout}   # request timeout
  tls_cert_path:                                # leave blank to not use https
  tls_key_path:                                 # leave blank to not use https
  port: ${toString cfg.server.port}
  base_path: ${cfg.server.basePath}
  public_url: ${cfg.server.publicUrl}  # required for links (e.g. password reset) in e-mail

app:
  aggregation_time: '${cfg.app.aggregationTime}'  # time at which to run daily aggregation batch jobs
  report_time_weekly: '${cfg.app.reportTimeWeekly}'  # time at which to fan out weekly reports (format: '<weekday)>,<daytime>')
  inactive_days: ${toString cfg.app.inactiveDays}  # time of previous days within a user must have logged in to be considered active
  import_batch_size: ${toString cfg.app.importBatchSize}  # maximum number of heartbeats to insert into the database within one transaction
  custom_languages:
${optionalString (cfg.app.customLanguages != null) "  ${concatStringsSep "\n  " (attrValues (mapAttrs (ext: lang: "${ext}: ${lang}") cfg.app.customLanguages))}"}

  # url template for user avatar images (to be used with services like gravatar or dicebear)
  # available variable placeholders are: username, username_hash, email, email_hash
  # avatar_url_template: https://avatars.dicebear.com/api/pixel-art-neutral/{username_hash}.svg
  avatar_url_template: ${cfg.app.avatarUrlTemplate}

db:
  host:                               # leave blank when using sqlite3
  port:                               # leave blank when using sqlite3
  user:                               # leave blank when using sqlite3
  password:                           # leave blank when using sqlite3
  name: /var/lib/wakapi/${cfg.dbFileName}  # database name for mysql / postgres or file path for sqlite (e.g. /tmp/wakapi.db)
  dialect: sqlite3                    # mysql, postgres, sqlite3
  charset: utf8mb4                    # only used for mysql connections
  max_conn: 2                         # maximum number of concurrent connections to maintain
  ssl: false                          # whether to use tls for db connection (must be true for cockroachdb) (ignored for mysql and sqlite)
  automgirate_fail_silently: false    # whether to ignore schema auto-migration failures when starting up


security:
  password_salt: ${toString cfg.security.passwordSalt}
  insecure_cookies: ${toString cfg.security.insecureCookies}
  cookie_max_age: ${toString cfg.security.cookieMaxAge}
  allow_signup: ${boolToString cfg.security.allowSignup}
  expose_metrics: ${toString cfg.security.exposeMetrics}
  enable_proxy: false                 # only intended for production instance at wakapi.dev

mail:
  enabled: ${boolToString cfg.smtp.enable}
  provider: smtp                        # method for sending mails, currently one of ['smtp', 'mailwhale']
  sender: ${cfg.smtp.sender}

  smtp:
    host: ${cfg.smtp.host}
    port: ${toString cfg.smtp.port}
    username: ${cfg.smtp.username}
    password: ${cfg.smtp.password}
    tls: ${toString cfg.smtp.tls}
''
