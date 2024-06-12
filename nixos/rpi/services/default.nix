{ ... }: {
  imports = [
    ./btrbk.nix
    ./rp.nix
  ];

  services = {
    acremote.enable = true;
    btrfs.autoScrub.fileSystems = [ "/elements" ];
    curltimesync = {
      enable = true;
      url = "114.222.113.139";  # im.qq.com
    };
    rustdesk-server = {
      enable = true;
      relayIP = "0.0.0.0";
    };
  };
}
