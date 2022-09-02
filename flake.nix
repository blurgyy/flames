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
    hydraJobs = with builtins; let
      allPackages = let
        builtSystems = [ "aarch64-linux" "x86_64-linux" ];
        removedSystems = attrNames (removeAttrs self.packages builtSystems);
      in removeAttrs self.packages removedSystems;
      allNixosConfigurations = listToAttrs (attrValues (mapAttrs
        (name: _: {
          inherit name;
          value = self.homeConfigurations.${name}.activationPackage;
        }) self.homeConfigurations
      ));
      allHomeConfigurations = listToAttrs (attrValues (mapAttrs
        (name: _: {
          inherit name;
          value = self.nixosConfigurations.${name}.config.system.build.toplevel;
        }) self.nixosConfigurations
      ));
    in allPackages // allNixosConfigurations // allHomeConfigurations;
  } // {
    nixosModules = import ./modules;
    overlays.default = my.overlay;
    homeConfigurations = import ./outputs/home.nix { inherit nixpkgs inputs self; };
    nixosConfigurations = import ./outputs/nixos.nix { inherit nixpkgs inputs self; };
  };
}
