{
  description = "Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl = {
      url = "github:guibou/nixgl";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    # extra-substituters = [ "https://cache.blurgy.xyz" ];
    # extra-trusted-public-keys = [ "cache.blurgy.xyz:Xg9PvXkUIAhDIsdn/NOUUFo+HHc8htSiGj7O6fUj/W4=" ];
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: let
    pkgs = import nixpkgs {
      inherit system;
      config = {
        # allowUnfree = true;
        # cudaSupport = true;
      };
      overlays = [
        self.overlays.default
        inputs.nixgl.overlays.default
      ];
    };
    inherit (nixpkgs) lib;
  in {
    packages = rec {
      # inherit (pkgs) myPackage;
      # default = myPackage;
    };
    devShells = rec {
      default = pureShell;
      pureShell = pkgs.mkShell {
        buildInputs = [
        ];
        shellHook = ''
          [[ "$-" == *i* ]] && exec "$SHELL"
        '';
      };
      impureShell = pureShell.overrideAttrs (o: {
        shellHook = ''
          source <(sed -Ee '/\$@/d' ${lib.getExe pkgs.nixgl.nixVulkanIntel})
          source <(sed -Ee '/\$@/d' ${lib.getExe pkgs.nixgl.nixGLIntel})
          source <(sed -Ee '/\$@/d' ${lib.getExe pkgs.nixgl.auto.nixGLNvidia}*)
        '' + o.shellHook or "";
      });
    };
  }) // {
    overlays.default = final: prev: let
      # version = "0.1.0";
    in {
      # myPackage = final.callPackage ./. {
      #   pname = ;
      #   src = ./.;
      #   inherit version;
      # };
    };
    hydraJobs = self.packages;
  };
}
