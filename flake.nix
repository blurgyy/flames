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
    sops-nix = { url = github:Mic92/sops-nix; inputs.nixpkgs.follows = "nixpkgs"; };
    nixgl = { url = github:guibou/nixGL; inputs.nixpkgs.follows = "nixpkgs"; };
    tex2nix = { url = github:Mic92/tex2nix; inputs.nixpkgs.follows = "nixpkgs"; };
    nickcao = { url = github:NickCao/flakes; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = github:berberman/nvfetcher; };

    nbfc-linux = { url = github:nbfc-linux/nbfc-linux; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote.url = gitlab:highsunz/acremote;
    carinae.url = github:NickCao/carinae;

    neovim = { url = github:neovim/neovim?dir=contrib; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }: let
    my = import ./packages;
  in flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
      config.allowBroken = true;
      overlays = [
        self.overlays.default
      ];
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
        preserveOnlyFrom = keys: attrset: foldl' (lhs: rhs: lhs // rhs) {} (map (key: { "${key}" = attrset.${key}; }) keys);
        preserveOnlyAmong = keys: attrsets: foldl'
          (lhs: rhs: listToAttrs (map
            (key: {
              name = key;
              value = (if (hasAttr key lhs) then lhs.${key} else {}) // (if (hasAttr key rhs) then rhs.${key} else {});
            })
            keys))
          {}
          (map (attrset: preserveOnlyFrom keys attrset) attrsets);
      in preserveOnlyAmong builtSystems [
        self.packages
        (mapAttrs (sys: pkg: { nvfetcher = pkg; }) inputs.nvfetcher.defaultPackage)
      ];
      builtPackages = mapAttrs
        (sys: pkgset: my.filterAttrs (name: pkg: !hasAttr "platforms" pkg.meta || elem sys pkg.meta.platforms) pkgset)
        allPackages;
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
    in builtPackages // allNixosConfigurations // allHomeConfigurations;
  } // {
    nixosModules = import ./modules;
    overlays.default = my.overlay;
    homeConfigurations = import ./outputs/home.nix { inherit nixpkgs inputs self; };
    nixosConfigurations = import ./outputs/nixos.nix { inherit nixpkgs inputs self; };
  };
}
