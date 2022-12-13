{ applyTag, mapDir }: {
  domainStrategy = "IPIfNonMatch";
  domainMatcher = "mph";
  rules = mapDir (path: { type = "field"; } // (import path)) ./rules;
}
