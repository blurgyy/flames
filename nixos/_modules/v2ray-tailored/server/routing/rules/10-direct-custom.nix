{
  domain = [
    "domain:gstatic.com"
    "domain:himself65.com"
    "domain:googleapis.com"
    "domain:cdn.jsdelivr.net"
    "domain:docs.microsoft.com"
    "domain:statsig.com"  # openai auth for the ChatGPT iOS app requires <api.statsig.com> to be reachable
  ];
  outboundTag = "direct:custom";
}
