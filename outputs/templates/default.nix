{ my }: with builtins; mapAttrs
  (name: _: {
    path = ./${name};
    description = ''flake template "${name}"'';
  })
  (my.filterAttrs (path: type: type == "directory") (readDir ./.))
