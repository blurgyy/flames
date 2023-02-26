{ inputs, self, my }: with builtins; let
  allPackages = let
    builtSystems = [ "aarch64-linux" "x86_64-linux" ];
    preserveOnlyFrom = keys: attrset: foldl' (lhs: rhs: lhs // rhs) {} (map (key: { "${key}" = attrset.${key}; }) keys);
    preserveOnlyAmong = keys: attrsets: foldl'
      (lhs: rhs: listToAttrs (map
        (key: {
          name = key;
          value = lhs.${key} or {} // rhs.${key} or {};
        })
        keys))
      {}
      (map (attrset: preserveOnlyFrom keys attrset) attrsets);
  in preserveOnlyAmong builtSystems [
    self.packages
    # (mapAttrs (sys: pkg: { nvfetcher = pkg.default; }) inputs.nvfetcher.packages)
  ];
  builtPackages = mapAttrs
    (sys: pkgset: my.filterAttrs (name: pkg: hasAttr "meta" pkg && (!hasAttr "platforms" pkg.meta || elem sys pkg.meta.platforms)) pkgset)
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
in builtPackages // allNixosConfigurations // allHomeConfigurations
