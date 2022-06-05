{ applyTag, importDir }: {
  domainStrategy = "IPIfNonMatch";
  domainMatcher = "mph";
  balancers = importDir (applyTag { }) ./balancers;
  rules = importDir (path: { type = "field"; } // (import path)) ./rules;
}
