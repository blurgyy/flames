{ dataRoot, webVault, listenPort }: ''
## Vaultwarden Configuration File
## Uncomment any of the following lines to change the defaults
##
## Be aware that most of these settings will be overridden if they were changed
## in the admin interface. Those overrides are stored within DATA_FOLDER/config.json .

## Main data folder
DATA_FOLDER=${dataRoot}

## Database URL
## When using SQLite, this is the path to the DB file, default to %DATA_FOLDER%/db.sqlite3
# DATABASE_URL=data/db.sqlite3
## When using MySQL, specify an appropriate connection URI.
## Details: https://docs.diesel.rs/diesel/mysql/struct.MysqlConnection.html
# DATABASE_URL=mysql://user:password@host[:port]/database_name
## When using PostgreSQL, specify an appropriate connection URI (recommended)
## or keyword/value connection string.
## Details:
## - https://docs.diesel.rs/diesel/pg/struct.PgConnection.html
## - https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING
# DATABASE_URL=postgresql://user:password@host[:port]/database_name

## Database max connections
## Define the size of the connection pool used for connecting to the database.
# DATABASE_MAX_CONNS=10

## Individual folders, these override %DATA_FOLDER%
# RSA_KEY_FILENAME=data/rsa_key
# ICON_CACHE_FOLDER=data/icon_cache
# ATTACHMENTS_FOLDER=data/attachments
# SENDS_FOLDER=data/sends

## Templates data folder, by default uses embedded templates
## Check source code to see the format
# TEMPLATES_FOLDER=/path/to/templates
## Automatically reload the templates for every request, slow, use only for development
# RELOAD_TEMPLATES=false

## Client IP Header, used to identify the IP of the client, defaults to "X-Real-IP"
## Set to the string "none" (without quotes), to disable any headers and just use the remote IP
# IP_HEADER=X-Real-IP

## Cache time-to-live for successfully obtained icons, in seconds (0 is "forever")
# ICON_CACHE_TTL=2592000
## Cache time-to-live for icons which weren't available, in seconds (0 is "forever")
# ICON_CACHE_NEGTTL=259200

## Web vault settings
WEB_VAULT_FOLDER=${webVault.root}
WEB_VAULT_ENABLED=${toString webVault.enable}

## Enables websocket notifications
# WEBSOCKET_ENABLED=false

## Controls the WebSocket server address and port
# WEBSOCKET_ADDRESS=0.0.0.0
# WEBSOCKET_PORT=3012

## Controls whether users are allowed to create Bitwarden Sends.
## This setting applies globally to all users.
## To control this on a per-org basis instead, use the "Disable Send" org policy.
# SENDS_ALLOWED=true

## Controls whether users can enable emergency access to their accounts.
## This setting applies globally to all users.
# EMERGENCY_ACCESS_ALLOWED=true

## Job scheduler settings
##
## Job schedules use a cron-like syntax (as parsed by https://crates.io/crates/cron),
## and are always in terms of UTC time (regardless of your local time zone settings).
##
## How often (in ms) the job scheduler thread checks for jobs that need running.
## Set to 0 to globally disable scheduled jobs.
# JOB_POLL_INTERVAL_MS=30000
##
## Cron schedule of the job that checks for Sends past their deletion date.
## Defaults to hourly (5 minutes after the hour). Set blank to disable this job.
# SEND_PURGE_SCHEDULE="0 5 * * * *"
##
## Cron schedule of the job that checks for trashed items to delete permanently.
## Defaults to daily (5 minutes after midnight). Set blank to disable this job.
# TRASH_PURGE_SCHEDULE="0 5 0 * * *"
##
## Cron schedule of the job that checks for incomplete 2FA logins.
## Defaults to once every minute. Set blank to disable this job.
# INCOMPLETE_2FA_SCHEDULE="30 * * * * *"
##
## Cron schedule of the job that sends expiration reminders to emergency access grantors.
## Defaults to hourly (5 minutes after the hour). Set blank to disable this job.
# EMERGENCY_NOTIFICATION_REMINDER_SCHEDULE="0 5 * * * *"
##
## Cron schedule of the job that grants emergency access requests that have met the required wait time.
## Defaults to hourly (5 minutes after the hour). Set blank to disable this job.
# EMERGENCY_REQUEST_TIMEOUT_SCHEDULE="0 5 * * * *"

## Enable extended logging, which shows timestamps and targets in the logs
# EXTENDED_LOGGING=true

## Timestamp format used in extended logging.
## Format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime
# LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S.%3f"

## Logging to file
## It's recommended to also set 'ROCKET_CLI_COLORS=off'
# LOG_FILE=/var/log/vaultwarden.log

## Logging to Syslog
## This requires extended logging
## It's recommended to also set 'ROCKET_CLI_COLORS=off'
# USE_SYSLOG=false

## Log level
## Change the verbosity of the log output
## Valid values are "trace", "debug", "info", "warn", "error" and "off"
## Setting it to "trace" or "debug" would also show logs for mounted
## routes and static file, websocket and alive requests
# LOG_LEVEL=Info

## Enable WAL for the DB
## Set to false to avoid enabling WAL during startup.
## Note that if the DB already has WAL enabled, you will also need to disable WAL in the DB,
## this setting only prevents vaultwarden from automatically enabling it on start.
## Please read project wiki page about this setting first before changing the value as it can
## cause performance degradation or might render the service unable to start.
# ENABLE_DB_WAL=true

## Database connection retries
## Number of times to retry the database connection during startup, with 1 second delay between each retry, set to 0 to retry indefinitely
# DB_CONNECTION_RETRIES=15

## Disable icon downloading
## Set to true to disable icon downloading, this would still serve icons from $ICON_CACHE_FOLDER,
## but it won't produce any external network request. Needs to set $ICON_CACHE_TTL to 0,
## otherwise it will delete them and they won't be downloaded again.
# DISABLE_ICON_DOWNLOAD=false

## Icon download timeout
## Configure the timeout value when downloading the favicons.
## The default is 10 seconds, but this could be to low on slower network connections
# ICON_DOWNLOAD_TIMEOUT=10

## Icon blacklist Regex
## Any domains or IPs that match this regex won't be fetched by the icon service.
## Useful to hide other servers in the local network. Check the WIKI for more details
## NOTE: Always enclose this regex within single quotes!
# ICON_BLACKLIST_REGEX='^(192\.168\.0\.[0-9]+|192\.168\.1\.[0-9]+)$'

## Any IP which is not defined as a global IP will be blacklisted.
## Useful to secure your internal environment: See https://en.wikipedia.org/wiki/Reserved_IP_addresses for a list of IPs which it will block
# ICON_BLACKLIST_NON_GLOBAL_IPS=true

## Disable 2FA remember
## Enabling this would force the users to use a second factor to login every time.
## Note that the checkbox would still be present, but ignored.
# DISABLE_2FA_REMEMBER=false

## Maximum attempts before an email token is reset and a new email will need to be sent.
# EMAIL_ATTEMPTS_LIMIT=3

## Token expiration time
## Maximum time in seconds a token is valid. The time the user has to open email client and copy token.
# EMAIL_EXPIRATION_TIME=600

## Email token size
## Number of digits in an email token (min: 6, max: 19).
## Note that the Bitwarden clients are hardcoded to mention 6 digit codes regardless of this setting!
# EMAIL_TOKEN_SIZE=6

## Controls if new users can register
# SIGNUPS_ALLOWED=true

## Controls if new users need to verify their email address upon registration
## Note that setting this option to true prevents logins until the email address has been verified!
## The welcome email will include a verification link, and login attempts will periodically
## trigger another verification email to be sent.
# SIGNUPS_VERIFY=false

## If SIGNUPS_VERIFY is set to true, this limits how many seconds after the last time
## an email verification link has been sent another verification email will be sent
# SIGNUPS_VERIFY_RESEND_TIME=3600

## If SIGNUPS_VERIFY is set to true, this limits how many times an email verification
## email will be re-sent upon an attempted login.
# SIGNUPS_VERIFY_RESEND_LIMIT=6

## Controls if new users from a list of comma-separated domains can register
## even if SIGNUPS_ALLOWED is set to false
# SIGNUPS_DOMAINS_WHITELIST=example.com,example.net,example.org

## Controls which users can create new orgs.
## Blank or 'all' means all users can create orgs (this is the default):
# ORG_CREATION_USERS=
## 'none' means no users can create orgs:
# ORG_CREATION_USERS=none
## A comma-separated list means only those users can create orgs:
# ORG_CREATION_USERS=admin1@example.com,admin2@example.com

## Token for the admin interface, preferably use a long random string
## One option is to use 'openssl rand -base64 48'
## If not set, the admin panel is disabled
# ADMIN_TOKEN=Vy2VyYTTsKPv8W5aEOWUbB/Bt3DEKePbHmI4m9VcemUMS2rEviDowNAFqYi1xjmp

## Enable this to bypass the admin panel security. This option is only
## meant to be used with the use of a separate auth layer in front
# DISABLE_ADMIN_TOKEN=false

## Invitations org admins to invite users, even when signups are disabled
# INVITATIONS_ALLOWED=true
## Name shown in the invitation emails that don't come from a specific organization
# INVITATION_ORG_NAME=Vaultwarden

## Per-organization attachment storage limit (KB)
## Max kilobytes of attachment storage allowed per organization.
## When this limit is reached, organization members will not be allowed to upload further attachments for ciphers owned by that organization.
# ORG_ATTACHMENT_LIMIT=
## Per-user attachment storage limit (KB)
## Max kilobytes of attachment storage allowed per user.
## When this limit is reached, the user will not be allowed to upload further attachments.
# USER_ATTACHMENT_LIMIT=

## Number of days to wait before auto-deleting a trashed item.
## If unset (the default), trashed items are not auto-deleted.
## This setting applies globally, so make sure to inform all users of any changes to this setting.
# TRASH_AUTO_DELETE_DAYS=

## Number of minutes to wait before a 2FA-enabled login is considered incomplete,
## resulting in an email notification. An incomplete 2FA login is one where the correct
## master password was provided but the required 2FA step was not completed, which
## potentially indicates a master password compromise. Set to 0 to disable this check.
## This setting applies globally to all users.
# INCOMPLETE_2FA_TIME_LIMIT=3

## Controls the PBBKDF password iterations to apply on the server
## The change only applies when the password is changed
# PASSWORD_ITERATIONS=100000

## Controls whether a password hint should be shown directly in the web page if
## SMTP service is not configured. Not recommended for publicly-accessible instances
## as this provides unauthenticated access to potentially sensitive data.
# SHOW_PASSWORD_HINT=false

## Domain settings
## The domain must match the address from where you access the server
## It's recommended to configure this value, otherwise certain functionality might not work,
## like attachment downloads, email links and U2F.
## For U2F to work, the server must use HTTPS, you can use Let's Encrypt for free certs
# DOMAIN=https://bw.domain.tld:8443

## Allowed iframe ancestors (Know the risks!)
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors
## Allows other domains to embed the web vault into an iframe, useful for embedding into secure intranets
## This adds the configured value to the 'Content-Security-Policy' headers 'frame-ancestors' value.
## Multiple values must be separated with a whitespace.
# ALLOWED_IFRAME_ANCESTORS=

## Yubico (Yubikey) Settings
## Set your Client ID and Secret Key for Yubikey OTP
## You can generate it here: https://upgrade.yubico.com/getapikey/
## You can optionally specify a custom OTP server
# YUBICO_CLIENT_ID=11111
# YUBICO_SECRET_KEY=AAAAAAAAAAAAAAAAAAAAAAAA
# YUBICO_SERVER=http://yourdomain.com/wsapi/2.0/verify

## Duo Settings
## You need to configure all options to enable global Duo support, otherwise users would need to configure it themselves
## Create an account and protect an application as mentioned in this link (only the first step, not the rest):
## https://help.bitwarden.com/article/setup-two-step-login-duo/#create-a-duo-security-account
## Then set the following options, based on the values obtained from the last step:
# DUO_IKEY=<Integration Key>
# DUO_SKEY=<Secret Key>
# DUO_HOST=<API Hostname>
## After that, you should be able to follow the rest of the guide linked above,
## ignoring the fields that ask for the values that you already configured beforehand.

## Authenticator Settings
## Disable authenticator time drifted codes to be valid.
## TOTP codes of the previous and next 30 seconds will be invalid
##
## According to the RFC6238 (https://tools.ietf.org/html/rfc6238),
## we allow by default the TOTP code which was valid one step back and one in the future.
## This can however allow attackers to be a bit more lucky with there attempts because there are 3 valid codes.
## You can disable this, so that only the current TOTP Code is allowed.
## Keep in mind that when a sever drifts out of time, valid codes could be marked as invalid.
## In any case, if a code has been used it can not be used again, also codes which predates it will be invalid.
# AUTHENTICATOR_DISABLE_TIME_DRIFT=false

## Rocket specific settings
## See https://rocket.rs/v0.4/guide/configuration/ for more details.
# ROCKET_ADDRESS=0.0.0.0
ROCKET_PORT=${listenPort}
# ROCKET_WORKERS=10
# ROCKET_TLS={certs="/path/to/certs.pem",key="/path/to/key.pem"}
ROCKET_LIMITS={json=10485760}

## Mail specific settings, set SMTP_HOST and SMTP_FROM to enable the mail service.
## To make sure the email links are pointing to the correct host, set the DOMAIN variable.
## Note: if SMTP_USERNAME is specified, SMTP_PASSWORD is mandatory
# SMTP_HOST=smtp.domain.tld
# SMTP_FROM=vaultwarden@domain.tld
# SMTP_FROM_NAME=Vaultwarden
# SMTP_PORT=587          # Ports 587 (submission) and 25 (smtp) are standard without encryption and with encryption via STARTTLS (Explicit TLS). Port 465 is outdated and used with Implicit TLS.
# SMTP_SSL=true          # (Explicit) - This variable by default configures Explicit STARTTLS, it will upgrade an insecure connection to a secure one. Unless SMTP_EXPLICIT_TLS is set to true. Either port 587 or 25 are default.
# SMTP_EXPLICIT_TLS=true # (Implicit) - N.B. This variable configures Implicit TLS. It's currently mislabelled (see bug #851) - SMTP_SSL Needs to be set to true for this option to work. Usually port 465 is used here.
# SMTP_USERNAME=username
# SMTP_PASSWORD=password
# SMTP_TIMEOUT=15

## Defaults for SSL is "Plain" and "Login" and nothing for Non-SSL connections.
## Possible values: ["Plain", "Login", "Xoauth2"].
## Multiple options need to be separated by a comma ','.
# SMTP_AUTH_MECHANISM="Plain"

## Server name sent during the SMTP HELO
## By default this value should be is on the machine's hostname,
## but might need to be changed in case it trips some anti-spam filters
# HELO_NAME=

## SMTP debugging
## When set to true this will output very detailed SMTP messages.
## WARNING: This could contain sensitive information like passwords and usernames! Only enable this during troubleshooting!
# SMTP_DEBUG=false

## Accept Invalid Hostnames
## DANGEROUS: This option introduces significant vulnerabilities to man-in-the-middle attacks!
## Only use this as a last resort if you are not able to use a valid certificate.
# SMTP_ACCEPT_INVALID_HOSTNAMES=false

## Accept Invalid Certificates
## DANGEROUS: This option introduces significant vulnerabilities to man-in-the-middle attacks!
## Only use this as a last resort if you are not able to use a valid certificate.
## If the Certificate is valid but the hostname doesn't match, please use SMTP_ACCEPT_INVALID_HOSTNAMES instead.
# SMTP_ACCEPT_INVALID_CERTS=false

## Require new device emails. When a user logs in an email is required to be sent.
## If sending the email fails the login attempt will fail!!
# REQUIRE_DEVICE_EMAIL=false

## HIBP Api Key
## HaveIBeenPwned API Key, request it here: https://haveibeenpwned.com/API/Key
# HIBP_API_KEY=

# vim: syntax=ini
''
