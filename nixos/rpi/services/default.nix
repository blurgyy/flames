{ ... }: {
  imports = [
    ./btrbk.nix
    ./rp.nix
  ];

  services = {
    acremote.enable = true;
    rustdesk-server.enable = true;
    btrfs.autoScrub.fileSystems = [ "/elements" ];
    curltimesync = {
      enable = true;
      url = "114.222.113.139";  # im.qq.com
    };
  };
}
