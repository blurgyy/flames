{ lib, my, definitionDir }: with builtins; {
  default = {
    imports = map
      (entry: import /${definitionDir}/${entry})
      (filter
        (name: name != "default.nix")
        (attrNames (readDir definitionDir)));
  };
} // lib.mapAttrs'
  (name: value: {
    name = if value == "directory" then name else (lib.removeSuffix ".nix" name);
    value = import /${definitionDir}/${name};
  })
  (my.filterAttrs
    (name: _: name != "default.nix")
    (readDir definitionDir))
