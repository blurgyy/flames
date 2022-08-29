{ config, pkgs, ... }: let
  sops-key-file = "/var/lib/${config.networking.hostName}.age";
in {
  sops = {
    defaultSopsFile = ../../../${config.networking.hostName}/secrets.yaml;
    age = {
      keyFile = sops-key-file;
      sshKeyPaths = [ ];  # Do not import ssh keys
    };
    gnupg.sshKeyPaths = [ ];  # Do not import ssh keys  
    secrets = {
      "passwords/root".neededForUsers = true;
      "passwords/gy".neededForUsers = true;
    };
  };
  environment.variables.SOPS_AGE_KEY_FILE = sops-key-file;
  users = let
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBF/xL6yptBusC9sW6/e+BLkvdgzI7g9MhaHIG127Q/A gy@cadliu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHM4yanex/42s/F9dP7CJ3BstzEC7n0qwi0+2hhxOAS6 gy@hooper"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1LWYTkOiaY/TSs9qoAAQm2tVHw4Lljz90pCREnW2Zx gy@FridaY"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdK4KWp4YMiDfq+hLZ3fQQ+02XnYhLY47l7Zro+xKud gy@watson"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItdYYARC78zBUAN4KA5DIPxYLxZQ5PBMVmgINyhyRJC gy@cube"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOyxiBbO6uQvG9B14K4neHMU3+PjA7sFuK3aqcF7voU gy@peterpan"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKaezYsGYIsrp9v9ZV3k6h92HIrdIfEfTnEyySq2sQ7W gy@cindy"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKco1z3uNTuYW7eVl2MTPrvVG5jnEnNJne/Us+LhKOwC gy@rpi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlMIWDojT8L4g7g0z6uC2EhALHr2fL/ZIdNnNiyggBj gy@HUAWEI"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1m/+k7RnoL1YVbP4vv8XTFnlP6CGmnXJfxA+Xu6H5q gy@morty"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEjbeH2P4cG/eIHeOm1FM1vqclsfvBSlz+76RNTGYG3 gy@cad-liu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlA0ON/HBEhGPo1Uu5lrgpbQ/D/Ivd7q3LuNTXScrRi gy@john"
    ];
  in {
    mutableUsers = false;
    groups.plocate = { };  # for plocate-updatedb.service
    users.root = {
      passwordFile = config.sops.secrets."passwords/root".path;
      openssh.authorizedKeys.keys = keys;
    };
    users.gy = {
      passwordFile = config.sops.secrets."passwords/gy".path;
      isNormalUser = true;
      extraGroups = [
        config.users.groups.keys.name 
        config.users.groups.wheel.name
        config.users.groups.video.name
        config.users.groups.plocate.name
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };
  };
}
