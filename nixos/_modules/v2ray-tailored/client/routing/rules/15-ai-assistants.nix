{
  domain = [
    # base domains can be used safely since ads are blocked in earlier rules
    "bing"
    "openai"
    "domain:bard.google.com"
  ];
  balancerTag = "best-us-server";
}
