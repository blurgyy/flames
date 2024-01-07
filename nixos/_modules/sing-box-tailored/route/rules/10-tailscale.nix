{
  ip_cidr = "100.64.0.0/10";
  process_name = [
    "tailscale"
    "tailscaled"
    ".tailscale-wrapped"
    ".tailscaled-wrapped"
  ];
  outbound = "tailscale-out";
}
