{ config, pkgs, utils, inputs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  listenPort = 2257;
  placeholderPath = "/proc/sys/kernel/random/boot_id";
in

{
  sops.secrets = (builtins.mapAttrs
    (name: value: {
      inherit (value) sopsFile;
      restartUnits = [ "rules-server-sing-box.service" ];
    })
    (import ../../_parts/proxy-secrets.nix).client)
    // {
      proxy-client-uuids.restartUnits = [ "rules-server-clash.service" ];
    };

  services.sing-box = {
    enable = false;
    preConfigure = true;
    secretPath = placeholderPath;
  };

  systemd.services.rules-server-sing-box = {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      ${utils.genJqSecretsReplacementSnippet config.services.sing-box.settings "/tmp/template.json"}
      jq 'del(.route.geoip) | del(.route.geosite) | .log.level="error" | .log.timestamp=true' /tmp/template.json >template.json
    '';
    path = with pkgs; [ jq coreutils gawk ];
    script = ''
      ${pkgs.sing-box-rules}/bin/sing-box-rules serve \
        ${pkgs.proxy-rules}/src \
        template.json \
        $CREDENTIALS_DIRECTORY/uuids \
        $(echo "${inputs.sing-man.packages.${system}.sing-man-windows}" | cut -d/ -f4 | cut -d- -f1) \
        $(echo "${inputs.sing-man.packages.${system}.sing-man-windows}" | awk -F- '{ print $NF }') \
        --port=${toString listenPort}
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
      requestRules = [ "replace-uri /sing-box(.*)$ \\1" ];
      server.address = "127.0.0.1:${toString listenPort}";
    };
  };
}
