{
  domain = [
    # base domains can be used safely since ads are blocked in earlier rules
    "bing"
    "bingapis"
    "claude"
    "live"
    "microsoft"
    "msftauth"
    "oaistatic"
    "oaiusercontent"
    "openai"
    "domain:bard.google.com"
    "domain:open.ai"
  ];
  outboundTag = "direct-ai-assistants";
}