{
  domain = [
    # base domains can be used safely since ads are blocked in earlier rules
    "bing"
    "bingapis"
    "claude"
    "microsoft"
    "msftauth"
    "oaistatic"
    "oaiusercontent"
    "openai"
    "chatgpt"
    "domain:bard.google.com"
    "domain:gemini.google.com"
    "domain:live.com"
    "domain:open.ai"
  ];
  balancerTag = "best:us-server";
}
