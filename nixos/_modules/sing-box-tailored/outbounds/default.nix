{ secretPath, mapDir, applyTag }:

builtins.concatLists [
  (mapDir applyTag ./trivial)
  (map (entry: entry // (if entry.type == "vmess" then { uuid._secret = secretPath; } else {})) (mapDir applyTag ./remote))
  (map (entry: entry // { interrupt_exist_connections = false; }) (mapDir applyTag ./urltest))
]
