{
  description = "Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hsz = { url = "gitlab:highsunz/flames"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixgl = { url = "github:guibou/nixgl"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ nixpkgs, flake-utils, hsz, ... }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      config = {
        # allowUnfree = true;
        # cudaSupport = true;
      };
      overlays = [
        inputs.nixgl.overlays.default
      ];
    };
    inherit (nixpkgs) lib;
  in {
    packages = rec {
      default = hello;
      hello = pkgs.hello;
    };
    devShells = rec {
      default = pureShell;
      pureShell = pkgs.mkShell {
        buildInputs = [
        ];
        shellHook = ''
          source ${hsz.packages.${system}.common-shell-hook}
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
  });
}
