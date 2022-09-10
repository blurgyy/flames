{ config, pkgs, ... }: {
  users = {
    users.hydra-distributed-builder = {
      group = config.users.groups.hydra-distributed-builder.name;
      isSystemUser = true;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtriLxUenvpPNbs7hDcAdlJjXmrl170dOjsoDXPWK2Q" ];
      shell = pkgs.bash;
    };
    groups.hydra-distributed-builder = {};
  };
  nix.settings.trusted-users = [ config.users.users.hydra-distributed-builder.name ];
}
