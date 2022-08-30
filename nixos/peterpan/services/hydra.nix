{ config, pkgs, ... }: {
  users.users.hydrabuilder = {
    group = config.users.groups.hydrabuilder.name;
    isSystemUser = true;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiW8FrX/Nfoqm7uocB7/OMPxmUxxKUMm8uU7ETm1J5r" ];
    shell = pkgs.bash;
  };
  users.groups.hydrabuilder = {};
  nix.settings.trusted-users = [ config.users.users.hydrabuilder.name ];
  services.v2ray-tailored.client.proxyBypassedIPs = [ "130.61.57.3" ];
}
