{ config, hostName, ... }: {
  sops = {
    defaultSopsFile = ../_secrets/gy.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "userKey/root@${hostName}".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
}
