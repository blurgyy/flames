{ config, pkgs, ... }: {
  users = {
    users.hydra-distributed-builder = {
      group = config.users.groups.hydra-distributed-builder.name;
      isSystemUser = true;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiW8FrX/Nfoqm7uocB7/OMPxmUxxKUMm8uU7ETm1J5r" ];
      shell = pkgs.bash;
    };
    groups.hydra-distributed-builder = {};
  };
  nix.settings.trusted-users = [ config.users.users.hydra-distributed-builder.name ];
  services.v2ray-tailored.client.proxyBypassedIPs = [ "130.61.57.3" ];
}
