{ secretPath, mapDir, applyTag }:

builtins.concatLists [
  (mapDir applyTag ./trivial)
  (map
    (entry: (if entry.type == "vmess"
      then {
        uuid._secret = secretPath;
      } else if entry.type == "urltest"
      then {
        interval = "150s";  # 2.5m
        tolerance = 50;  # ms
      } else {}) // entry)
    (mapDir applyTag ./remote))
  (map (entry: { interrupt_exist_connections = false; } // entry) (mapDir applyTag ./urltest))
]
