{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    flake-utils.url = github:numtide/flake-utils;
    #nixpkgs.url = github:NixOS/nixpkgs;
    nixos-cn = { url = github:nixos-cn/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; inputs.nixpkgs.follows = "nixpkgs"; };
    nbfc-linux = { url = github:nbfc-linux/nbfc-linux; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote = { url = gitlab:highsunz/acremote; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, nixos-cn, ... }: let
    my = import ./packages;
  in flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        self.overlays.default
        nixos-cn.overlay
      ];
    };
  in {
    packages = my.packages pkgs;
    commonShellHook = import ./outputs/commonShellHook.nix { inherit pkgs; };
  }) // {
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
