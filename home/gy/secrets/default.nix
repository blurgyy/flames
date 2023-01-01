{ config, pkgs, lib, ... }: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.sessionVariables.XDG_DATA_HOME}/${config.home.username}.age";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "file/netrc".path = "${config.home.homeDirectory}/.netrc";  # REF: <https://docs.wandb.ai/guides/track/advanced/environment-variables>
      "file/telegram-send.conf".path = "${config.xdg.configHome}/telegram-send.conf";
    };
  };
}
