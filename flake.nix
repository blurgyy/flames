{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    flake-utils.url = github:numtide/flake-utils;
    nixos-generators.url = github:nix-community/nixos-generators;
    #nixpkgs.url = github:NixOS/nixpkgs;
    nixos-cn = { url = github:nixos-cn/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    nixgl = { url = github:guibou/nixGL; inputs.nixpkgs.follows = "nixpkgs"; };

    nbfc-linux = { url = github:nbfc-linux/nbfc-linux; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote = { url = gitlab:highsunz/acremote; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, nixos-cn, ... }: let
    my = import ./packages;
  in flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
    };
  in rec {
    packages = my.packages pkgs;
    apps.gpustat = let
      gpustat-wrapped = pkgs.writeShellScriptBin "gpustat" ''
        source ${inputs.nixgl.packages.${system}.nixGLNvidia}/bin/nixGL*
        tmpfile=$(mktemp /tmp/gpustat-XXXXXX)
        trap "rm $tmpfile" EXIT
        while ${packages.gpustat-rs}/bin/gpustat --color "$@" >$tmpfile; do
          clear && ${pkgs.coreutils}/bin/cat $tmpfile
          sleep 1
        done
      '';
    in {
      type = "app";
      program = "${gpustat-wrapped}/bin/gpustat";
    };
    commonShellHook = import ./outputs/commonShellHook.nix { inherit pkgs; };
  }) // {
    overlays.default = my.overlay;
    nixosConfigurations = {
      cube = import ./machines/cube {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
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
