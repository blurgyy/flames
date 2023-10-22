{
  type = "urltest";
  outbounds = [
    "cn-00"
    "direct-zju-internal"
  ];
  # WARN: Must use direct IP connection here, because both zju DNS also depends on this
  url = "http://10.10.98.98/";  # www.cc98.org
  # url = "http://10.50.200.3/";  # net2.zju.edu.cn
  # url = "http://10.50.200.245/";  # net.zju.edu.cn
}
