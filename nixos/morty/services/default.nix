{ ... }: {
  imports = [
    ./rp.nix
  ];

  services = {
    btrfs.autoScrub.fileSystems = [ "/elements" ];
    logind.lidSwitch = "ignore";
    rustdesk-server = {
      enable = true;
      relayIP = "0.0.0.0";
    };
  };
}
