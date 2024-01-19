{ config, pkgs, utils, ... }:

let
  listenPort = 2257;
  placeholderPath = "/proc/sys/kernel/random/boot_id";
in

{
  sops.secrets = builtins.listToAttrs (map
    (secret: {
      name = secret;
      value = {
        restartUnits = [ "rules-server-sing-box.service" ];
      };
    })
    (let
      proxyClientSecrets = import ../../_parts/proxy-client-secrets.nix;
    in proxyClientSecrets.domains ++ proxyClientSecrets.addresses)
  );

  services.sing-box = {
    enable = false;
    preConfigure = true;
    secretPath = placeholderPath;
  };

  systemd.services.rules-server-sing-box = rec {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      cd /run/${serviceConfig.RuntimeDirectory}
      cp ${pkgs.cgi-rules-server}/bin/sing-box .
      ${utils.genJqSecretsReplacementSnippet config.services.sing-box.settings "/tmp/template.json"}
      jq 'del(.route.geoip) | del(.route.geosite) | .log.level="error" | .log.timestamp=true' /tmp/template.json >template.json
      ${pkgs.proxy-rules}/bin/populate-sing-box-rules ${pkgs.proxy-rules}/src template.json
      rm /tmp/template.json
      cp $CREDENTIALS_DIRECTORY/uuids uuids
      chmod 644 uuids
    '';
    path = [
      pkgs.thttpd
      pkgs.jq
    ];
    script = ''
      thttpd \
        -d /run/${serviceConfig.RuntimeDirectory} \
        -p ${toString listenPort} \
        -c "/sing-box" \
        -D
    '';
    serviceConfig = {
      DynamicUser = false;
      LoadCredential = [
        "uuids:${config.sops.secrets.proxy-client-uuids.path}"
      ];
      RuntimeDirectory = "rules-server-sing-box";
      # If `DynamicUser` is disabled, directories needs to have the x permission set, otherwise
      # thttpd gives the least helpful message:
      #   "There was an unusual problem serving the requested URL '/some-path'."
      # REF: <https://wl500g.info/archive/index.php/t-7534.html>
      RuntimeDirectoryMode = "0711";  # drwx--x--x
      Restart = "always";
      RestartSec = 5;
      PrivateTmp = true;
    };
  };

  services.haproxy-tailored = {
    frontends.tls-offload-front.backends = [
      { name = "rules-server-sing-box"; condition = "if { path_beg /sing-box/ }"; }
    ];
    backends.rules-server-sing-box = {
      mode = "http";
      server.address = "127.0.0.1:${toString listenPort}";
    };
  };
}
