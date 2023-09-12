{ ... }: {
  imports = [];

  services.curltimesync = {
    enable = true;
    url = "109.244.194.121";  # tencent.com
  };
}
