{
  process_name = [
    "nc"

    "nscd"
    "nsncd"

    "radicle-node"
    ".radicle-node-wrapped"

    "sing-man"

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
