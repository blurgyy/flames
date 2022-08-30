{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;
    nix-std.url = github:chessai/nix-std;
    flake-utils.url = github:numtide/flake-utils;
    nixos-generators.url = github:nix-community/nixos-generators;
    #nixpkgs.url = github:NixOS/nixpkgs;
    nixos-cn = { url = github:nixos-cn/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = github:nix-community/home-manager; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    nixgl = { url = github:guibou/nixGL; inputs.nixpkgs.follows = "nixpkgs"; };
    tex2nix = { url = github:Mic92/tex2nix; inputs.nixpkgs.follows = "nixpkgs"; };

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
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };
  in rec {
    packages = my.packages pkgs;
    apps.gpustat = let
      gpustat-wrapped = pkgs.writeShellScriptBin "gpustat" ''
        source <(sed -e 's/"\$@"//g' ${inputs.nixgl.packages.${system}.nixGLNvidia}/bin/nixGL*)
        ${pkgs.viddy}/bin/viddy --no-title --interval=1 --pty -- \
          ${packages.gpustat-rs}/bin/gpustat "$@"
      '';
    in {
      type = "app";
      program = "${gpustat-wrapped}/bin/gpustat";
    };
    commonShellHook = import ./outputs/commonShellHook.nix { inherit pkgs; };
  }) // {
    hydraJobs = with builtins; self.packages.x86_64-linux //
    (listToAttrs (attrValues (mapAttrs
      (name: _: {
        inherit name;
        value = self.homeConfigurations.${name}.activationPackage;
      }) self.homeConfigurations
    ))) // (listToAttrs (attrValues (mapAttrs
      (name: _: {
        inherit name;
        value = self.nixosConfigurations.${name}.config.system.build.toplevel;
      }) self.nixosConfigurations
    )));
  } // {
    homeConfigurations = let
      lib = nixpkgs.lib;
      x86_64-non-headless = {
        system = "x86_64-linux";
        headless = false;
        inherit nixpkgs inputs self;
      };
      x86_64-headless = {
        system = "x86_64-linux";
        inherit nixpkgs inputs self;
      };
      aarch64-headless = {
        system = "aarch64-linux";
        inherit nixpkgs inputs self;
      };
    in rec {
      "gy@cindy" = import ./home/gy aarch64-headless;
      "gy@cadliu" = import ./home/gy (x86_64-headless // { proxy = { addr = "192.168.1.25"; port = "9990"; }; });
      "gy@cad-liu" = self.homeConfigurations."gy@cadliu";
      "gy@morty" = import ./home/gy x86_64-non-headless;
      "gy@rpi" = import ./home/gy aarch64-headless;
      gy = import ./home/gy x86_64-headless;
    };
    nixosModules = import ./modules;
    overlays.default = my.overlay;
    nixosConfigurations = {
      cindy = import ./nixos/cindy {
        system = "aarch64-linux";
        inherit self nixpkgs inputs;
      };
      cube = import ./nixos/cube {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
      morty = import ./nixos/morty {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
      peterpan = import ./nixos/peterpan {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
      rpi = import ./nixos/rpi {
        system = "aarch64-linux";
        inherit self nixpkgs inputs;
      };
    } // {
      installer-aarch64 = import ./nixos/installer {
        system = "aarch64-linux";
        inherit self nixpkgs inputs;
      };
      installer-x86_64 = import ./nixos/installer {
        system = "x86_64-linux";
        inherit self nixpkgs inputs;
      };
    };
  };
}
