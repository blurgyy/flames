{ mapDir, call }:

{
  ## nixpkgs' sing-box module already sets these
  # geoip =
  # geosite =

  rules = mapDir (path: call path {}) ./rules;

  auto_detect_interface = true;
  final = "auto-oversea";
}
