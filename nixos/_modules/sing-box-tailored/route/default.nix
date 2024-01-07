{ mapDir, applyTag, call }:

{
  rules = mapDir (path: call path {}) ./rules;

  rule_set = mapDir applyTag ./rule_set;

  auto_detect_interface = true;
  final = "auto-oversea";
}
