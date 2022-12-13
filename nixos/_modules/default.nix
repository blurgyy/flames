{
  default = with builtins; {
    imports = map
      (entry: import ./${entry})
      (filter
        (name: name != "default.nix")
        (attrNames (readDir ./.)));
  };
}
