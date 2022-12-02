{ config, ... }: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.sessionVariables.XDG_DATA_HOME}/${config.home.username}.age";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "api/wandb.ai".path = "%r/api/wandb.ai/key";  # WANDB_API_KEY, REF: <https://docs.wandb.ai/guides/track/advanced/environment-variables>
    };
  };
}
