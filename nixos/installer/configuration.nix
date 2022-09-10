{ lib, pkgs, ... }: {
  users.users.root.openssh.authorizedKeys.keys = import ../_parts/defaults/public-keys.nix;

  networking.hostName = "installer";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";
  console = {
    useXkbConfig = true;
    font = "ter-i24b";
    packages = with pkgs; [ terminus_font ];
  };
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; lib.mkForce [ git neovim ];

  system.stateVersion = "22.11";
}
