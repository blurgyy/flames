{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-std.url = "github:chessai/nix-std";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-cn = { url = "github:nixos-cn/flakes"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    sops-nix = { url = "github:Mic92/sops-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixgl = { url = "github:guibou/nixGL"; inputs.nixpkgs.follows = "nixpkgs"; };
    tex2nix = { url = "github:Mic92/tex2nix"; };
    nickcao = { url = "github:NickCao/flakes"; inputs.nixpkgs.follows = "nixpkgs"; };
    nvfetcher = { url = "github:berberman/nvfetcher"; };
    colmena = { url = "github:zhaofengli/colmena"; inputs.nixpkgs.follows = "nixpkgs"; };

    hyprland = { url = "github:hyprwm/hyprland"; inputs.nixpkgs.follows = "nixpkgs"; };
    hypr-execonce-helper = { url = "gitlab:highsunz/hypr-execonce-helper"; inputs.nixpkgs.follows = "nixpkgs"; };
    hyprpaper = { url = "github:hyprwm/hyprpaper"; inputs.nixpkgs.follows = "nixpkgs"; };
    nbfc-linux = { url = "github:nbfc-linux/nbfc-linux"; inputs.nixpkgs.follows = "nixpkgs"; };
    acremote.url = "gitlab:highsunz/acremote";
    carinae.url = "github:NickCao/carinae";
  };

  # `self` denotes this flake, otther function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }: let
    my = import ./packages;
  in flake-utils.lib.eachDefaultSystem (system: let
    overlaysInUse = [
      self.overlays.default
    ];
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
      config.allowBroken = true;
      overlays = overlaysInUse;
    };
  in rec {
    inherit overlaysInUse;  # For use in hydra jobsets (`overlays.${system}`)
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
  }) // {
    hydraJobs = import ./outputs/jobs.nix { inherit inputs self my; };
    nixosModules = import ./modules;
    overlays.default = my.overlay;
    homeConfigurations = import ./outputs/home.nix { inherit nixpkgs inputs self; };
    nixosConfigurations = import ./outputs/nixos.nix { inherit nixpkgs inputs self; };
    colmena = import ./outputs/colmena.nix { inherit nixpkgs inputs self; };
  };
}
