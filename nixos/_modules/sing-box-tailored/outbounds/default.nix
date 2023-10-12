{ mapDir, applyTagWithOverrides }:

builtins.concatLists (map
  (mapDir (applyTagWithOverrides {}))
  [
    ./trivial
    ./remote
    ./urltest
  ]
)
