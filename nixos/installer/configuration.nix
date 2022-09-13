{ config, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/installer/netboot/netboot.nix"
  ];

  boot.supportedFilesystems = [ "btrfs" ];

  users.users.root.openssh.authorizedKeys.keys = import ../_parts/defaults/public-keys.nix;
  services = {
    openssh.enable = true;
    udisks2.enable = false;
  };

  networking = {
    hostName = "installer";
    useNetworkd = true;
    firewall.enable = false;
  };
  time.timeZone = "UTC";

  environment.systemPackages = with pkgs; [ bash git neovim ];

  system.build.netboot = let
    build = config.system.build;
    kernelTarget = pkgs.stdenv.hostPlatform.linux-kernel.target;
  in with pkgs; runCommand "installer-${pkgs.system}-netboot" {} ''
    mkdir -p $out
    ln -s ${build.kernel}/${kernelTarget}         $out/${kernelTarget}
    ln -s ${build.netbootRamdisk}/initrd          $out/initrd
    ln -s ${build.netbootIpxeScript}/netboot.ipxe $out/ipxe
  '';
  #${zstd}/bin/zstd -d ${build.netbootRamdisk}/initrd -o $out/initrd

  system.stateVersion = "22.11";
}
