{ self, nixpkgs, inputs }: let
  lib = nixpkgs.lib;
  apply = userName: attrs: lib.mapAttrs' (hostName: params: {
    name = "${userName}@${hostName}";
    value = import ../home/gy (params // { inherit hostName; });
  }) attrs;
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

  labProxy = {
    addr = "winston";
    port = 1988;
    ignore = [
      "localhost"
      "127.0.0.1"
      "::1"
      "cc98.org"
      "nexushd.org"
      "zju.edu.cn"
    ];
  };
in apply "gy" {
  "morty" = x86_64-non-headless;
  "john" = x86_64-non-headless;
  "rpi" = aarch64-headless;
  "opi" = aarch64-headless;
  "copi" = aarch64-headless;

  "winston" = x86_64-non-headless // { proxy = labProxy; };
  "meda" = x86_64-headless;

  # set IP of winston in hosts
  "cadliu" = x86_64-headless // { proxy = labProxy; };
  "cad-liu" = x86_64-headless // { proxy = labProxy; };
  "mono" = x86_64-headless // { proxy = labProxy; };

  "cindy" = aarch64-headless;
  "peterpan" = x86_64-headless;
  "penta" = x86_64-headless;
  "quad" = x86_64-headless;
  "rubik" = x86_64-headless;
}
