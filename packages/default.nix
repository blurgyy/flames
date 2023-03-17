let
  filterAttrs = predicate: attrs: with builtins; listToAttrs (filter
    (v: v != null)
    (attrValues (mapAttrs
      (name: value: if (predicate name value) then { inherit name value; } else null)
      attrs)
    )
  );
  mapPackage = f: with builtins; mapAttrs
    (name: _: f name)
    (filterAttrs
      (name: type: type == "directory" && name != "_sources")
      (readDir ./.));
in {
  inherit filterAttrs;
  packages = pkgs: mapPackage (name: pkgs.${name});
  overlay = final: prev: mapPackage (name: let
    generated = final.callPackage ./_sources/generated.nix {};
    package = import ./${name};
    args = with builtins; intersectAttrs (functionArgs package) {
      inherit generated;
      source = generated.${name};
    };
  in
    final.callPackage package args
  );
}
