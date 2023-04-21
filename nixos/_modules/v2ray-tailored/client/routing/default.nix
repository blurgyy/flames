{ applyTag, filterMapDir, mapDir, disabledRoutingRules }: {
  domainStrategy = "IPIfNonMatch";
  domainMatcher = "mph";
  balancers = mapDir (applyTag { }) ./balancers;
  rules = filterMapDir
    (path: { type = "field"; } // (import path))
    (basename: !(builtins.elem basename disabledRoutingRules))
    ./rules;
}
