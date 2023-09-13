{ writeShellScriptBin
, coreutils-full
, rdesktop
}: writeShellScriptBin "printer" ''
  ${coreutils-full}/bin/yes 'yes' | ${rdesktop}/bin/rdesktop 10.76.2.85 -u cadliu -p lxg -r disk:h=''${XDG_RUNTIME_DIR:-/tmp}/printer
''
