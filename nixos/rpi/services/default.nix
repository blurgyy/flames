{ ... }: {
  imports = [
    ./btrbk.nix
  ];

  services = {
    acremote.enable = true;
    rustdesk-server.enable = true;
    btrfs.autoScrub.fileSystems = [ "/elements" ];
    curltimesync = {
      enable = true;
      url = "109.244.194.121";  # tencent.com
    };
  };
}
