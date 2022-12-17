{ my }: with builtins; mapAttrs
  (name: _: { path = ./${name}; })
  (my.filterAttrs (path: type: type == "directory") (readDir ./.))
