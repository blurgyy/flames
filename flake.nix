{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        stable.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    carinae = {
      url = "github:NickCao/carinae";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    tex2nix = {
      url = "github:Mic92/tex2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    ntfy-bridge = {
      url = "gitlab:highsunz/ntfy-bridge";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    acremote = {
      url = "gitlab:highsunz/acremote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    adrivems.url = "gitlab:highsunz/aliyundrive-mediaserver";
    dcompass.url = "github:compassd/dcompass";
    hypr-msg-handler.url = "gitlab:highsunz/hypr-msg-handler";
    orangepi-3-lts-nixos.url = "gitlab:highsunz/orangepi-3-lts-nixos";
  };

  # `self` denotes this flake, other function arguments are the flakes
  # specified in the `inputs` attribute above.
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:

  let
    my = import ./packages;
    cudaOverlay = final: prev: let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (prev) system config;
      };
    in {
      # use cudaPackages (cudatoolkit, etc.) from locked nixpkgs to avoid mass recompilation and
      # downloads.
      inherit (pkgs-stable) cudaPackages cudatoolkit openai-whisper;
    };
  in

  flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
      config.allowBroken = true;
      overlays = [
        cudaOverlay
        self.overlays.default
      ] ++ self.sharedOverlays;
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
  }) // {
    hydraJobs = import ./outputs/jobs.nix { inherit inputs self my; };
    nixosModules = import ./outputs/modules.nix { inherit my; inherit (nixpkgs) lib; definitionDir = ./nixos/_modules; };
    overlays.default = my.overlay;
    templates = import ./outputs/templates { inherit my; };
    homeConfigurations = import ./outputs/home.nix { inherit nixpkgs inputs self; };
    homeManagerModules = import ./outputs/modules.nix { inherit my; inherit (nixpkgs) lib; definitionDir = ./home/_modules; };
    nixosConfigurations = import ./outputs/nixos.nix { inherit nixpkgs inputs self; };
    colmena = import ./outputs/colmena.nix { inherit nixpkgs inputs self; };
    sharedOverlays = [
      inputs.adrivems.overlays.default
      inputs.colmena.overlays.default
      inputs.dcompass.overlays.default
      inputs.nvfetcher.overlays.default
      cudaOverlay
    ];
  };
}
