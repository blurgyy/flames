{
  type = "urltest";
  outbounds = [
    "cn-00"
    "direct-zju-internal"
  ];
  url = "http://www.cc98.org";
  interval = "1m";
  tolerance = 50;
  interrupt_exist_connections = true;
}
