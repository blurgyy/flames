{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    #nixpkgs.url = github:NixOS/nixpkgs;
    nixos-cn = { url = github:nixos-cn/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; inputs.nixpkgs.follows = "nixpkgs"; };
    nbfc-linux = { url = github:nbfc-linux/nbfc-linux; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote-backend = { url = gitlab:highsunz/acremote-backend; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, ... }: let
    my = import ./packages;
  in {
    packages = {
      x86_64-linux = {
        packages = my.packages;
      };
    };
    overlays.default = my.overlay;
    nixosConfigurations = {
      morty = import ./machines/morty {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
      rpi = import ./machines/rpi {
        system = "aarch64-linux";
        inherit self nixpkgs inputs;
      };
    };
  };
}
