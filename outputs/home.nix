{ self, nixpkgs, inputs }: let
  apply = attrs: builtins.mapAttrs (name: params:
    import ../home/gy (params // { inherit name; })
  ) attrs;
  x86_64-non-headless = {
    system = "x86_64-linux";
    headless = false;
    inherit self nixpkgs inputs;
  };
  x86_64-headless = {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  aarch64-headless = {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };
in apply {
  "gy@cindy" = aarch64-headless;
  # set IP of watson in hosts
  "gy@cadliu" = x86_64-headless // { proxy = { addr = "watson"; port = "9990"; }; };
  "gy@cad-liu" = x86_64-headless // { proxy = { addr = "watson"; port = "9990"; }; };
  "gy@morty" = x86_64-non-headless;
  "gy@john" = x86_64-non-headless;
  "gy@watson" = x86_64-non-headless;
  "gy@rpi" = aarch64-headless;
  gy = x86_64-headless;
}
