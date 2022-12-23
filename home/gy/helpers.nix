{ pkgs, lib }: with builtins; rec {
  mergeAttrsList = attrList: foldl' (x: y: x // y) {} attrList;

  mirrorDirsAsXdg = let
    loadFile = with builtins; { config, path }: if lib.hasSuffix ".asnix" path
      then let
        f = import path;
        type = typeOf f;
      in if type == "lambda"
        then let
            args = (intersectAttrs (functionArgs f) { inherit config pkgs lib; });
          in f args
        else f
      else readFile path;
    mirrorSingleDirAsXdgInner = { config, pathPrefix, path }: mapAttrs
        (subPath: type:
          if type == "regular" then
            {
              name = "${path}/${lib.removeSuffix ".asnix" subPath}";
              value = {
                text = loadFile { inherit config; path = (pathPrefix + "/${path}/${subPath}"); };
                # setting force=true will unconditionally replace target path
                force = true;  # REF: https://github.com/nix-community/home-manager/issues/6#issuecomment-693001293
              };
            }
          else
            (mirrorSingleDirAsXdgInner {
              inherit config pathPrefix;
              path = "${path}/${subPath}";
            })
        )
        (readDir (pathPrefix + "/${path}"));
    mirrorDirAsXdg = { config, pathPrefix, path }: listToAttrs (lib.collect
      (x: x ? name && x ? value)
      (mirrorSingleDirAsXdgInner { inherit config pathPrefix path; }));
  in
    { config, pathPrefix, paths }: mergeAttrsList (map
      (path: mirrorDirAsXdg { inherit config pathPrefix path; })
      paths
    );
  manifestXdgConfigFilesFrom = { config, pathPrefix }: mirrorDirsAsXdg {
    inherit config pathPrefix;
    paths = (map
      (path: lib.last (lib.splitString "/" path))
      (attrNames (readDir pathPrefix)));
  };
}
