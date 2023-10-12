{
  ip_cidr = "100.0.0.0/8";
  process_name = [
    "tailscale"
    "tailscaled"
    ".tailscale-wrapped"
    ".tailscaled-wrapped"
  ];
  outbound = "tailscale-out";
}
