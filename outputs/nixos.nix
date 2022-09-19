{ self, nixpkgs, inputs }: {
  cindy = import ../nixos/cindy {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };
  cube = import ../nixos/cube {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  morty = import ../nixos/morty {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  peterpan = import ../nixos/peterpan {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  rpi = import ../nixos/rpi {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };
  trigo = import ../nixos/trigo {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
  rubik = import ../nixos/rubik {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
} // {
  installer-aarch64 = import ../nixos/installer {
    system = "aarch64-linux";
    inherit self nixpkgs inputs;
  };
  installer-x86_64 = import ../nixos/installer {
    system = "x86_64-linux";
    inherit self nixpkgs inputs;
  };
}
