{ config, hostName, ... }: {
  sops = {
    defaultSopsFile = ../_secrets/gy.yaml;
    age.keyFile = "${config.home.sessionVariables.XDG_DATA_HOME}/${config.home.username}.age";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "file/netrc".path = "${config.home.homeDirectory}/.netrc";  # REF: <https://docs.wandb.ai/guides/track/advanced/environment-variables>
      "file/tro-config".path = "${config.xdg.configHome}/tro/config.toml";
      "file/telegram-send.conf".path = "${config.xdg.configHome}/telegram-send.conf";
      "file/cargo-credentials".path = "${config.home.sessionVariables.CARGO_HOME}/credentials";
      "file/copilot-hosts-json".path = "${config.xdg.configHome}/github-copilot/hosts.json";
      "file/github-cli-config".path = "${config.xdg.configHome}/gh/config.yml";
      "file/github-cli-hosts".path = "${config.xdg.configHome}/gh/hosts.yml";
      "file/nvchecker-keyfile".path = "${config.xdg.configHome}/nvchecker/keyfile.toml";  # nvfetcher -k ~/.config/nvchecker/keyfile.toml ...

      "userKey/gy@${hostName}".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
}
