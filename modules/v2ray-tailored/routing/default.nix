{ applyTag, mapDir }: {
  domainStrategy = "IPIfNonMatch";
  domainMatcher = "mph";
  balancers = mapDir (applyTag { }) ./balancers;
  rules = mapDir (path: { type = "field"; } // (import path)) ./rules;
}
