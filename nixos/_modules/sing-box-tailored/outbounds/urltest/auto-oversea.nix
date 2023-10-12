{
  type = "urltest";
  outbounds = [
    "auto-eu"
    "auto-jp"
    "auto-us"
  ];
  url = "https://www.gstatic.com/generate_204";
  interval = "1m";
  tolerance = 50;
  interrupt_exist_connections = true;
}
