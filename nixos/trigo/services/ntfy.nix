{ config, ... }: {
  services.ntfy-tailored = {
    enable = true;
    domain = config.networking.fqdn;
  };
}
