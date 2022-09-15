let
  filterAttrs = predicate: attrs: with builtins; listToAttrs (filter
    (v: v != null)
    (attrValues (mapAttrs
      (name: value: if (predicate name value) then { inherit name value; } else null)
      attrs)
    )
  );
  mapPackage = f: with builtins; listToAttrs (map
    (name: { inherit name; value = f name; })
    (attrNames (filterAttrs
      (name: type: type == "directory" && name != "_sources")
      (readDir ./.)
    ))
  );
in {
  inherit filterAttrs;
  packages = pkgs: mapPackage (name: pkgs.${name});
  overlay = final: prev: mapPackage (name: let
    generated = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit fetchFromGitHub; };
    package = import ./${name};
    args = with builtins; intersectAttrs (functionArgs package) { source = generated.${name}; };
  in
    final.callPackage package args
  );
}
