{ self, nixpkgs, inputs }: let
  apply = attrs: builtins.mapAttrs
    (name: params: import ../nixos/${name} (params // { inherit name; }))
    attrs;
  aarch64 = {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };
  x86_64 = {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
in apply {
  cindy = aarch64;
  cube = x86_64;
  morty = x86_64;
  peterpan = x86_64;
  quad = x86_64;
  rpi = aarch64;
  rubik = x86_64;
  trigo = x86_64;
}
