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
      url = "baidu.com";
    };
  };
}
