{ config, ... }: {
  networking.nftables.ruleset = builtins.readFile ../_parts/raw/nftables-default.conf;
  services.haproxy-tailored = import ./haproxy.nix { inherit config; };
}
