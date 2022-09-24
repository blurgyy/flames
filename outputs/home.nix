{ self, nixpkgs, inputs }: let
  lib = nixpkgs.lib;
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
in rec {
  "gy@cindy" = import ../home/gy aarch64-headless;
  "gy@cadliu" = import ../home/gy (x86_64-headless // { proxy = { addr = "192.168.1.25"; port = "9990"; }; });
  "gy@cad-liu" = self.homeConfigurations."gy@cadliu";
  "gy@morty" = import ../home/gy x86_64-non-headless;
  "gy@watson" = import ../home/gy x86_64-non-headless;
  "gy@rpi" = import ../home/gy aarch64-headless;
  gy = import ../home/gy x86_64-headless;
}
