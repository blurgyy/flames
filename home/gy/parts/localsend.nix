{ config, lib, pkgs, hostName, ... }:

let
  package = pkgs.localsend;
  configDir = "${config.xdg.dataHome}/localsend_app";
  privKeyPath = "${configDir}/localsend_key.pem";
  pubKeyPath = "${configDir}/localsend_pub.pem";
  certPath = "${configDir}/localsend_cert.pem";

  _settings = {
    version = 998244353;
    show_token._cmd = "${pkgs.util-linux}/bin/uuidgen";
    alias = hostName;
    security_context._secret = securityContextJsonOutput;
    color = "system";
    theme = "system";
    port = 53317;  # this is the default
    destination = "/home/gy/Downloads/localsend";
    save_to_history = false;
    minimize_to_tray = true;
    window_height = 768.0;
    window_width = 512.0;
    window_offset_x = 103.0;
    window_offset_y = 103.0;
  };

  settings = lib.mapAttrs'
    (name: value: { name = "flutter.ls_${name}"; inherit value; })
    _settings;
  securityContext = {
    privateKey._secret = privKeyPath;
    publicKey._secret = pubKeyPath;
    certificate._secret = certPath;
    certificateHash = "";  # this field must exist but it seems an empty value doesn't matter
  };

  settingsJsonRaw = pkgs.writeText "settings.json" (builtins.toJSON settings);
  settingsJsonOutput = "${configDir}/shared_preferences.json";

  securityContextJsonRaw = pkgs.writeText "security_context.json" (builtins.toJSON securityContext);
  securityContextJsonOutput = "${configDir}/security_context.json";

  writeConfig = pkgs.writeShellScript "write-localsend-script" ''
    ${pkgs.coreutils-full}/bin/mkdir -p ${configDir}
    ${pkgs.coreutils-full}/bin/yes "" |
      ${pkgs.openssl}/bin/openssl req -x509 \
        -newkey rsa:2048 \
        -keyout ${privKeyPath} \
        -out ${certPath} \
        -sha256 \
        -days 36500 \
        -nodes
    ${pkgs.openssl}/bin/openssl rsa -in ${privKeyPath} -pubout >${pubKeyPath}
    ${pkgs.genJqSecretsReplacementSnippet}/bin/do ${securityContextJsonRaw} ${securityContextJsonOutput}
    ${pkgs.genJqSecretsReplacementSnippet}/bin/do ${settingsJsonRaw} ${settingsJsonOutput}
    ${pkgs.coreutils-full}/bin/rm -v ${privKeyPath} ${certPath} ${pubKeyPath} ${securityContextJsonOutput}
  '';
in

{
  home.packages = [
    package
  ];

  systemd.user.services.localsend = {
    Unit.PartOf = [ "graphical-session.target" ];
    Service = {
      ExecStartPre = writeConfig;
      ExecStart = "${lib.getExe package}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
