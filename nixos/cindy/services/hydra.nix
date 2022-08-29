{ config, ... }: let
  hydraDomain = "hydra.${config.networking.domain}";
in {
  services.haproxy-tailored = {
    frontends.tls-offload-front = {
      acls = [ { name = "is_hydra"; body = "hdr(host) -i ${hydraDomain}"; } ];
      domain.extraNames = [ hydraDomain ];
    };
  };
  services.hydra = {
    enable = true;
    hydraURL = "https://${hydraDomain}";
    notificationSender = "hydra@${config.networking.domain}";
    listenHost = "127.0.0.1";
    port = 5813;
    useSubstitutes = true;
    buildMachinesFiles = [];
  };
}
