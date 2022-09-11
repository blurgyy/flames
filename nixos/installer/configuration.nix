{ lib, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    supportedFilesystems = [ "btrfs" ];
  };

  users.users.root.openssh.authorizedKeys.keys = import ../_parts/defaults/public-keys.nix;
  services = {
    udisks2.enable = false;
    openssh.enable = true;
  };

  networking = {
    hostName = "installer";
    useNetworkd = true;
    firewall.enable = false;
  };
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; lib.mkForce [ git neovim ];

  system.stateVersion = "22.11";
}
