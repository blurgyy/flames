{ ... }: {
  imports = [];

  services.curltimesync = {
    enable = true;
    url = "baidu.com";
  };
}
