{ config, pkgs, lib, ... }: {
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.sessionVariables.XDG_DATA_HOME}/${config.home.username}.age";
    secrets = {  # use %r for $XDG_RUNTIME_DIR, use %% for a literal `%`
      "file/netrc".path = "%r/hm/file/netrc";  # REF: <https://docs.wandb.ai/guides/track/advanced/environment-variables>
      "file/telegram-send.conf".path = "%r/hm/file/telegram-send.conf";
    };
  };

  home.activation = let
    check-symlink-target = pkgs.writeShellScript "check-symlink-target" ''
      $DRY_RUN_CMD set -Eeuo pipefail
      if [[ "$#" -ne 2 ]]; then
        echo "$0 accepts exactly 2 arguments but got $#" >&2
        exit 2
      fi
      source="$1"  # the symlink source
      target="$2"  # the symlink target
      echo -n "checking secret file symlink .. "
      if [[ -e "$target" ]] && [[ "$(readlink "$target")" != "$source" ]]; then
        echo "Error! '$target' exists and is not a symlink to '$source'" >&2
        exit 2
      fi
      echo "   Ok: '$target' does not exist or is already a symlink pointing to '$source'"
    '';
    header = ''
      $DRY_RUN_CMD set -Eeuo pipefail
      XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
      XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-"$HOME/.config"}
    '';
    sourceTargetPairs = [
      { source = "$XDG_RUNTIME_DIR/hm/file/netrc"; target = "$HOME/.netrc"; }
      { source = "$XDG_RUNTIME_DIR/hm/file/telegram-send.conf"; target = "$XDG_CONFIG_HOME/telegram-send.conf"; }
    ];
  in {
    secretsCheck = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      ${header}
      ${lib.concatStringsSep "\n" (map
        (pair: "${check-symlink-target} ${pair.source} ${pair.target}")
        sourceTargetPairs
      )}
    '';
    secretsLink = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${header}
      ${lib.concatStringsSep "\n" (map
        (pair: "[[ -e ${pair.target} ]] || $DRY_RUN_CMD ln -sf $VERBOSE_ARG ${pair.source} ${pair.target}")
        sourceTargetPairs
      )}
    '';
  };
}
