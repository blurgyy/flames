{ zjuConditionalOutbound, ... }:

{
  domain_keyword = [
    "cc98"
    "nexushd"
  ];
  domain_suffix = [
    ".zju.edu.cn"
  ];
  ip_cidr = [  # calculated with <https://www.ipaddressguide.com/cidr>
    "10.189.128.0/7"  # ZJUWLAN
    "10.76.0.0/21"    # CAD cable
  ];
  outbound = zjuConditionalOutbound;
}
