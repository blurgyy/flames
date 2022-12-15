{ lib, my }: with builtins; {
  default = {
    imports = map
      (entry: import ./${entry})
      (filter
        (name: name != "default.nix")
        (attrNames (readDir ./.)));
  };
} // lib.mapAttrs'
  (name: value: {
    name = if value == "directory" then name else (lib.removeSuffix ".nix" name);
    value = import ./${name};
  })
  (my.filterAttrs
    (name: _: name != "default.nix")
    (readDir ./.))
