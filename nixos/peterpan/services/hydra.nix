{ config, ... }: {
  users.users.hydra-builder = {
    group = config.users.groups.hydra-builder.name;
    isSystemUser = true;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiW8FrX/Nfoqm7uocB7/OMPxmUxxKUMm8uU7ETm1J5r" ];
  };
  users.groups.hydra-builder = {};
  nix.settings.trusted-users = [ config.users.users.hydra-builder.name ];
  services.v2ray-tailored.client.proxyBypassedIPs = [ "130.61.57.3" ];
}
