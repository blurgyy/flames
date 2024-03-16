{ ... }: {
  imports = [
    ./rp
  ];

  services.curltimesync = {
    enable = true;
    url = "114.222.113.139";  # im.qq.com
  };
}
