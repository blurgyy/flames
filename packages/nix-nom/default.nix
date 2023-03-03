{ writeShellScriptBin
, nix
, nix-output-monitor }: writeShellScriptBin "nix" ''
  set -Eeuo pipefail

  nix_bin="${nix}/bin/nix"

  if [[ -z "''${__called+1}" ]] && [[ "$1" =~ build|develop|shell ]]; then
    nom_bin="${nix-output-monitor}/bin/nom"
    __called=1 exec "$nom_bin" "$@"
  else
    exec "$nix_bin" "$@"
  fi
''
