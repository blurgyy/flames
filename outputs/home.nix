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

  labProxy = {
    addr = "winston";
    port = 1990;
    ignore = [
      "localhost"
      "127.0.0.1"
      "::1"
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

  "gy@winston" = x86_64-non-headless // { proxy = labProxy; };
  "gy@meda" = x86_64-headless // {
    proxy = {
      addr = "172.30.96.1";
      port = "9990";
      ignore = [
        "localhost"
        "127.0.0.1"
        "::1"
      ];
    };
  };

  # set IP of winston in hosts
  "gy@cadliu" = x86_64-headless // { proxy = labProxy; };
  "gy@cad-liu" = x86_64-headless // { proxy = labProxy; };

  "gy@cindy" = aarch64-headless;
  "gy@peterpan" = x86_64-headless;
  "gy@penta" = x86_64-headless;
  "gy@quad" = x86_64-headless;
  "gy@rubik" = x86_64-headless;
}
