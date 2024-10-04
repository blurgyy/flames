{ config, userName, hostName, ... }: {
  sops = {
    defaultSopsFile = ../../_secrets/${userName}.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "userKey/${userName}@${hostName}".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      "radicle-private-key".path = "${config.home.homeDirectory}/.radicle/keys/radicle";
    };
  };
}
