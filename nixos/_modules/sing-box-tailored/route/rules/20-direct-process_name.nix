{
  process_name = [
    "nc"

    "nscd"
    "nsncd"

    "sshd"

    "systemd-timesyncd"

    "tailscale"
    "tailscaled"
    ".tailscale-wrapped"
    ".tailscaled-wrapped"

    "transmission-daemon"

    "v2ray"
    ".v2ray-wrapped"

    "warp-svc"
    ".warp-svc-wrapped"
  ];
  outbound = "direct-process";
}
