{ config, pkgs, ... }: {
  users = {
    users.distributed-builder = {
      group = config.users.groups.distributed-builder.name;
      isSystemUser = true;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtriLxUenvpPNbs7hDcAdlJjXmrl170dOjsoDXPWK2Q" ];
      shell = pkgs.bash;
    };
    groups.distributed-builder = {};
  };
  nix.settings = {
    trusted-users = [ config.users.users.distributed-builder.name ];
    keep-going = true;
  };
}
