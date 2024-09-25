{ config, mapDir, applyTag, call }:

{
  rules = mapDir (path: call path {}) ./rules;

  rule_set = mapDir applyTag ./rule_set;

  final = "auto-oversea";
} // (if config.networking.nat.enable
then {
  default_interface = config.networking.nat.externalInterface;
} else {
  auto_detect_interface = true;
})
