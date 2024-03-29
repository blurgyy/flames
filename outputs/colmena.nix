{ self, nixpkgs, inputs }: let
  # Create an attrset, where the attr names are the same as the attr names of the input
  # `nixosConfigurations`, and the attr values are generated by the input `getResultFn`.
  # `getResultFn` takes two arguments, `hostName` and `cfg`, being the machine's hostname and the
  # machine's nix configurations, respectively.
  mapHosts = getResultFn: nixosConfigurations:
    builtins.mapAttrs
      getResultFn
      nixosConfigurations;
in {
  meta = {
    # REF: <https://github.com/zhaofengli/colmena/issues/54>
    nixpkgs.lib = inputs.nixpkgs.lib;
    nodeNixpkgs = mapHosts
      (_: cfg:
        import nixpkgs {
          inherit (cfg.config.nixpkgs) system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.default
          ];
        }
      )
      self.nixosConfigurations;

    # NOTE: Introduced in zhaofengli/colmena/pull/100, to be included in colmena's 0.4.0 release.
    nodeSpecialArgs = mapHosts
      (_: _: { inherit self inputs; })
      self.nixosConfigurations;
  };

  defaults.deployment = {
    buildOnTarget = true;
    #replaceUnknownProfiles = false;
    allowLocalDeployment = true;
  };
}

# REF: <https://github.com/zhaofengli/colmena/issues/60#issuecomment-1047199551>
// mapHosts
    (hostName: cfg: {
      imports = cfg._module.args.modules;
    })
    self.nixosConfigurations
