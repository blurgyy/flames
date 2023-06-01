{ config, lib, ... }: let
  certFile = "/var/lib/acme/${config.networking.fqdn}/cert.pem";
  keyFile = "/var/lib/acme/${config.networking.fqdn}/key.pem";

  imapDomain = "imap.${config.networking.domain}";
  smtpDomain = "smtp.${config.networking.domain}";

  mailHome = "/var/spool/mail";

  dovecot2RuntimeDir = "/run/dovecot2";
  dovecot2AuthPostfixListener = "auth-postfix";
in {
  services = {
    postfix = {
      enable = true;

      rootAlias = config.users.users.gy.name;
      mapFiles.senders = builtins.toFile "senders" ''
        # [email_address]               [sasl_login_name]
        gy@blurgy.xyz                   gy

        notification-bot@blurgy.xyz     notification-bot
        hydra@blurgy.xyz                notification-bot
        wakapi@blurgy.xyz               notification-bot

        benetjohn0@blurgy.xyz           benetjohn0
      '';
      extraAliases = ''
        spam: gy
        admin: gy
        notification-bot: gy
        benetjohn0: gy

        ## (below aliases are copied from previous default archlinux config)

        # General redirections for pseudo accounts
        bin:        root
        daemon:     root
        named:      root
        nobody:     root
        uucp:       root
        www:        root
        ftp-bugs:   root
        postfix:    root

        # Well-known aliases
        manager:    root
        dumper:     root
        operator:   root
        abuse:      postmaster

        # trap decode to catch security attacks
        decode:     root

        ## (above aliases are copied from previous default archlinux config)
      '';

      origin = config.networking.domain;
      domain = config.networking.domain;

      config = {  # REF: man:postconf(5)
        smtpd_banner = "$myhostname ESMTP $mail_name ($mail_version)";
        smtpd_helo_required = true;

        smtpd_tls_security_level = "may";
        smtpd_tls_auth_only = true;

        smtpd_tls_cert_file = certFile;
        smtpd_tls_key_file = keyFile;

        smtpd_helo_restrictions = [
          "permit_sasl_authenticated"
          "reject_non_fqdn_helo_hostname"
          "reject_unknown_hostname"
        ];
        smtpd_delay_reject = true;
        smtpd_sasl_type = "dovecot";
        smtpd_sasl_path = "${dovecot2RuntimeDir}/${dovecot2AuthPostfixListener}";
        smtpd_sasl_auth_enable = true;
        mydestination = [
          config.networking.domain  # Default value only contains below 3 entries thus rejects mails sent to the <@blurgy.xyz> domain.
          "$myhostname"
          "localhost.$mydomain"
          "localhost"
        ];
        smtpd_recipient_restrictions = [
          "permit_auth_destination"  # Allow mydestination as mail destination.
          "permit_mynetworks"
          "permit_sasl_authenticated"
          "reject_unauth_destination"
        ];
      };

      masterConfig = let
        mkKeyVal = opt: val: [ "-o" (opt + "=" + val) ];
        mkOpts = opts: lib.concatLists (lib.mapAttrsToList mkKeyVal opts);
      in {
        submission = {  # :587
          type = "inet";
          private = false;
          command = "smtpd";
          args = mkOpts {
            smtpd_tls_security_level = "encrypt";
            smtpd_sasl_auth_enable = "yes";
            smtpd_sasl_type = "dovecot";
            smtpd_sasl_path = "${dovecot2RuntimeDir}/${dovecot2AuthPostfixListener}";
            smtpd_sender_login_maps = "hash:/etc/postfix/senders";  # NOTE: use jointly with mapFiles.senders (see above)
            smtpd_client_restrictions = "permit_sasl_authenticated,reject";
            smtpd_sender_restrictions = "reject_sender_login_mismatch";
            smtpd_recipient_restrictions = "reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject";
            smtpd_relay_restrictions = "permit_sasl_authenticated,reject";
            # smtpd_upstream_proxy_protocol = "haproxy";
          };
        };
      };
    };

    dovecot2 = {
      enable = true;
      enablePAM = false;
      sslServerCert = certFile;
      sslServerKey = keyFile;
      extraConfig = ''
        base_dir = ${dovecot2RuntimeDir}

        mail_home = ${mailHome}
        mail_location = maildir:${mailHome}/%u

        passdb {
          args = scheme=PLAIN username_format=%n ${config.sops.secrets.dovecot-users.path}
          driver = passwd-file
        }

        userdb {
          args = username_format=%n ${config.sops.secrets.dovecot-users.path}
          auth_verbose = default
          driver = passwd-file
        }

        service auth {
          unix_listener ${dovecot2AuthPostfixListener} {
            mode = 0660
            user = ${config.services.postfix.user}
            group = ${config.services.postfix.group}
          }
        }
      '';
    };
  };

  sops.secrets = {
    dovecot-users = {
      owner = config.services.dovecot2.user;
      group = config.services.dovecot2.group;
    };
  };

  users.users = {
    postfix.extraGroups = [ config.users.groups.haproxy.name ];
    dovecot2.extraGroups = [ config.users.groups.haproxy.name ];
    gy.extraGroups = [ config.services.dovecot2.group ];
  };

  systemd.tmpfiles.rules = [
    "d ${mailHome} 1777 root root -"
  ];

  networking.firewall-tailored = {
    acceptedPorts = [{
      port = 25;
      protocols = [ "tcp" ];
      comment = "mail receiving";
    } {
      port = 587;
      protocols = [ "tcp" ];
      comment = "mail submission";
    } {
      port = 993;
      protocols = [ "tcp" ];
      comment = "imaps";
    }];
  };

  services.haproxy-tailored.
    frontends.tls-offload-front.
      domain.extraNames = [ imapDomain smtpDomain config.networking.domain ];
}
