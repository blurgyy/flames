{
  type = "urltest";
  outbounds = [
    "eu-00"
    "eu-01"
    "wss-eu-00"
    "wss-eu-01"
  ];
  url = "https://www.gstatic.com/generate_204";
  interval = "1m";
  tolerance = 50;
  interrupt_exist_connections = true;
}