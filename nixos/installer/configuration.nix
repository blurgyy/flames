{ lib, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    supportedFilesystems = [ "btrfs" ];
  };

  users.users.root.openssh.authorizedKeys.keys = import ../_parts/defaults/public-keys.nix;
  services.openssh.enable = true;

  networking = {
    hostName = "installer";
    useNetworkd = true;
    firewall.enable = false;
  };
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
