{ ... }: {
  imports = [
    ./containers.nix
    ./rp.nix
  ];

  services = {
    btrfs.autoScrub.fileSystems = [ "/atom" ];
    logind.lidSwitch = "ignore";
    rustdesk-server = {
      enable = true;
      relayIP = "0.0.0.0";
    };
  };
}
