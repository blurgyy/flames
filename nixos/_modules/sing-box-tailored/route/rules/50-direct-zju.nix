{
  domain = [
    "imap.zju.edu.cn"
    "mail.zju.edu.cn"
    "mirrors.zju.edu.cn"
    "net.zju.edu.cn"
    "net1.zju.edu.cn"
    "net2.zju.edu.cn"
    "net3.zju.edu.cn"
    "tracker.nexushd.org"
  ];
  domain_suffix = [
    ".imap.zju.edu.cn"
    ".mail.zju.edu.cn"
    ".mirrors.zju.edu.cn"
    ".net.zju.edu.cn"
    ".net1.zju.edu.cn"
    ".net2.zju.edu.cn"
    ".net3.zju.edu.cn"
    ".tracker.nexushd.org"
  ];
  # cc98 and main site of nexushd.org should be proxied conditioned on machine, do not include them
  outbound = "direct-zju";
}
