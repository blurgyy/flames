{ config, lib, applyTag, mapDir }: {
  domainStrategy = "IPIfNonMatch";
  domainMatcher = "mph";
  rules = let
    loadPath = with builtins; path: let
      f = import path;
    in if (typeOf f) != "lambda"
      then f
      else f (intersectAttrs (functionArgs f) { inherit config lib; });
  in mapDir (path: { type = "field"; } // (loadPath path)) ./rules;
}
