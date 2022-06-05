{ config }: ''
define ssh_scanners = {
  5.181.80.124,
  10.12.12.231,
  10.14.28.116,
  10.72.100.14,
  10.76.1.48,
  10.78.92.47,
  10.99.232.15,
  10.214.0.0/16,
  10.39.0.0/16,
  20.210.218.95,
  43.134.209.38,
  45.232.244.5,
  46.101.245.139,
  49.232.175.27,
  50.0.0.0/7,
  58.243.202.94,
  64.227.180.27,
  67.205.165.57,
  85.185.161.202,
  91.109.5.28,
  94.232.44.73,
  101.33.238.117,
  106.12.151.33,
  116.21.204.72,
  121.0.0.0/8,
  123.7.75.33,
  129.152.14.197,
  137.184.0.0/16,
  139.162.177.94,
  142.0.0.0/7,
  146.190.236.146,
  157.245.36.140,
  159.23.30.147,
  159.223.44.143,
  159.223.225.5,
  164.0.0.0/6,
  174.138.60.34,
  176.0.0.0/4,
  178.128.236.11,
  179.43.133.98,
  184.0.0.0/5,
  193.169.255.57,
  196.1.97.216,
  202.112.61.102,
  206.189.224.124,
  206.189.142.123,
  207.154.210.35,
  211.36.158.253,
  213.194.99.235,
  222.186.153.230,
}

define smtp_scanners = {
  85.206.160.0/24,  # Lithuania/India
  185.25.0.0/16,    # Lithuania
  188.138.0.0/16,   # Germany
  212.83.132.206,   # France
}

# Flush ruleset so that always a clean ruleset is loaded
flush ruleset

table inet filter
delete table inet filter
table inet filter {
  chain input {
    type filter hook input priority filter
    policy drop

    ct state invalid drop comment "early drop of invalid connections"
    ct state {established, related} accept comment "allow tracked connections"
    iifname lo accept comment "allow from loopback"
    ip protocol icmp accept comment "allow icmp"

    ip saddr $ssh_scanners counter drop comment "reject known ssh scanners"

    ip saddr $smtp_scanners counter drop comment "reject known smtp spammers"

    meta l4proto ipv6-icmp accept comment "allow icmp v6"
    tcp dport ssh accept comment "allow sshd"
    tcp dport {http, https} accept comment "allow http and https"
    tcp dport smtp counter accept comment "count and allow smtp receiving"
    tcp dport submission counter accept comment "count and allow secured smtp"
    tcp dport imaps accept comment "count and allow secured imap"
    tcp dport {
      ${config.sops.placeholder."ports/rathole/rpi/ssh"},
      ${config.sops.placeholder."ports/rathole/rpi/acremote"},
      ${config.sops.placeholder."ports/rathole/watson/ssh"},
      ${config.sops.placeholder."ports/rathole/morty/ssh"},
      ${config.sops.placeholder."ports/rathole/data-channel"},
    } counter accept comment "allow reverse-proxied services"
    # REF: [RFC1918](https://datatracker.ietf.org/doc/html/rfc1918#section-3)
    ip saddr {
      10.0.0.0/8,
      172.16.0.0/12,
      192.168.0.0/16,
    } tcp dport 9990 accept comment "allow machines from private network ranges to access http proxy"
    pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    counter
  }
  chain forward {
    type filter hook forward priority filter
    policy drop
  }
  chain output {
    type filter hook output priority filter
    policy accept

    tcp dport smtp counter accept comment "outgoing smtp traffic, compare with accepted submission traffic in the 'input' chain to see if there is spamming behaviour"
  }
}

define proxy_bypassed_IPs = {
  100.64.0.0/10,
  127.0.0.0/8,
  169.254.0.0/16,
  172.16.0.0/12,
  192.168.0.0/16,
  224.0.0.0/4,
  240.0.0.0/4,
  255.255.255.255/32,
  130.162.238.248,
  ${config.sops.placeholder."server-addresses/hooper"},
  ${config.sops.placeholder."server-addresses/cindy"},
  ${config.sops.placeholder."server-addresses/peterpan"},
}

table ip transparent_proxy
delete table ip transparent_proxy
table ip transparent_proxy {
  chain prerouting {
    type filter hook prerouting priority mangle
    policy accept

    iifname != "lo" return

    ip daddr $proxy_bypassed_IPs return

    # Don't redirect packets that has already passed a transparent proxy
    meta l4proto {tcp, udp} socket transparent 1 meta mark 0x9973 return
    # Don't redirect packets from v2ray (set `sockopt.mark=27` for all
    # outbounds in v2ray for this
    meta l4proto {tcp, udp} socket transparent 1 meta mark 27 return
    # Only redirect packets with mark 0x9973 to :9900
    meta l4proto {tcp, udp} meta mark 0x9973 tproxy to :9900
  }

  chain output {
    type route hook output priority mangle
    policy accept

    ip daddr $proxy_bypassed_IPs return

    socket cgroupv2 level 1 "system.slice" socket cgroupv2 level 2 != "system.slice/nix-daemon.service" return
    meta l4proto {tcp, udp} meta mark set 0x9973
  }
}
''
