let
  mapPackage = f: with builtins; listToAttrs (map
    (name: { inherit name; value = f name; })
    (filter
        (v: v != null)
        (attrValues (mapAttrs
          (path: type: if type == "directory" && path != "_sources" then path else null)
          (readDir ./.)
        ))
    )
  );
in {
  packages = pkgs: mapPackage (name: pkgs.${name});
  overlay = final: prev: mapPackage (name: let
    generated = (import ./_sources/generated.nix) { inherit (final) fetchurl fetchgit fetchFromGitHub; };
    package = import ./${name};
    args = with builtins; intersectAttrs (functionArgs package) { source = generated.${name}; };
  in
    final.callPackage package args
  );
}
