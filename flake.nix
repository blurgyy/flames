{
  description = "highsunz's flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-2311.url = "github:NixOS/nixpkgs/release-23.11";
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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
    fixenc.url = "gitlab:highsunz/fixenc";
    hypr-msg-handler.url = "gitlab:highsunz/hypr-msg-handler";
    meaney.url = "github:blurgyy/meaney";
    orangepi-3-lts-nixos.url = "gitlab:highsunz/orangepi-3-lts-nixos";
    sing-man.url = "gitlab:highsunz/sing-man";
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
      # # use cudaPackages (cudatoolkit, etc.) from locked nixpkgs to avoid mass recompilation and
      # # downloads.
      # inherit (pkgs-stable) cudaPackages cudatoolkit openai-whisper;
    };
    stableOverlays = final: prev: let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (prev) system config;
      };
    in {
      inherit (pkgs-stable)
        haproxy

        minecraft
        steam

        rustdesk

        swaylock-effects
        ;
    };
    workingFcitx5UiNvimOverlay = final: prev: let
      pkgs-2311 = import inputs.nixpkgs-2311 {
        inherit (prev) system config;
        overlays = [ self.overlays.default ];
      };
    in {
      inherit (pkgs-2311) vim-plugin-fcitx5-ui-nvim;
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
        stableOverlays
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
    nixosConfigurations = import ./outputs/nixos.nix { inherit inputs self; };
    colmena = import ./outputs/colmena.nix { inherit nixpkgs inputs self; };
    sharedOverlays = [
      inputs.colmena.overlays.default
      inputs.dcompass.overlays.default
      inputs.fixenc.overlays.default
      cudaOverlay
      stableOverlays
      workingFcitx5UiNvimOverlay
    ];
  };
}
