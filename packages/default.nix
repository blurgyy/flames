let
  mapPackage = f: with builtins; listToAttrs ( map
    (name: { inherit name; value = f name; })
    (filter
        (v: v != null)
        (attrValues ( mapAttrs
          (path: type: if type == "directory" then path else null)
          (readDir ./.)
        ))
    )
  );
in {
  packages = pkgs: mapPackage (name: pkgs.${name});
  overlay = final: prev: mapPackage ( name: let
    package = import ./${name};
    args = builtins.intersectAttrs ( builtins.functionArgs package ) { inherit final prev; };
  in
    final.callPackage package args
  );
}
