{ writeShellScriptBin
, handlr
}: writeShellScriptBin "xdg-open" ''
  ${handlr}/bin/handlr open "$@"
''
