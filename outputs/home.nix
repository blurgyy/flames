{ self, nixpkgs, inputs }: let
  lib = nixpkgs.lib;
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
in apply rec {
  "gy@cindy" = aarch64-headless;
  "gy@cadliu" = x86_64-headless // { proxy = { addr = "192.168.1.25"; port = "9990"; }; };
  "gy@cad-liu" = self.homeConfigurations."gy@cadliu";
  "gy@morty" = x86_64-non-headless;
  "gy@watson" = x86_64-non-headless;
  "gy@rpi" = aarch64-headless;
  gy = x86_64-headless;
}
