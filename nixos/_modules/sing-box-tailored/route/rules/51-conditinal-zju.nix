{ config, ... }:

{
  domain_keyword = [
    "cc98"
    "nexushd"
  ];
  outbound = if config.services.sing-box.needProxyForZju
    then "auto-cn"
    else "direct-zju-internal";
}
