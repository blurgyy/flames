{ config, lib, pkgs, ... }: let
  cfg = config.programs.supervisedDesktopEntries;
in {
  options.programs.supervisedDesktopEntries = with lib; {
    enable = mkEnableOption "Whether to add a supervised counterpart for each installed desktop entry";
    mark = mkOption {
      type = types.str;
      default = "supervised";
      description = ''
        Newly added desktop entries will have filename (\${mark}-<name>.desktop), and the display
        name will be `<original name> (\${mark})`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (
        (pkgs.callPackage ../../packages/supervisedDesktopEntries.nix {})
        {
          inputPackages = config.home.packages;
          mark = cfg.mark;
        }
      )
    ];
  };
}
