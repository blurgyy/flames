{ secretPath, mapDir, applyTag }:

builtins.concatLists [
  (mapDir applyTag ./trivial)
  (map (entry: entry // { uuid._secret = secretPath; }) (mapDir applyTag ./remote))
  (map (entry: entry // { interrupt_exist_connections = false; }) (mapDir applyTag ./urltest))
]
