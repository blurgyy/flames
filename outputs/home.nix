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

  proxy = {
    addr = "watson";
    port = 1990;
    ignore = [
      "cc98.org"
      "nexushd.org"
      "zju.edu.cn"
    ];
  };
in apply {
  "gy@morty" = x86_64-non-headless;
  "gy@john" = x86_64-non-headless;
  "gy@rpi" = aarch64-headless;
  "gy@opi" = aarch64-headless;
  "gy@copi" = aarch64-headless;

  "gy@watson" = x86_64-non-headless // { inherit proxy; };

  # set IP of watson in hosts
  "gy@cadliu" = x86_64-headless // { inherit proxy; };
  "gy@cad-liu" = x86_64-headless // { inherit proxy; };

  "gy@cindy" = aarch64-headless;
  "gy@cube" = x86_64-headless;
  "gy@peterpan" = x86_64-headless;
  "gy@quad" = x86_64-headless;
  "gy@rubik" = x86_64-headless;
  "gy@trigo" = x86_64-headless;
}
