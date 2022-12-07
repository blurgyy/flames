{ stdenv, lib
, sdwrap
}:

# This is a function for generating desktop entries that wrap the processes of the launched
# application inside a cgroup.  A new desktop entry is generated for each desktop entry that was
# provided by a package with the filename prefixed with `supervised-` and the entry name suffixed
# with `(supervised)`.
#
#   Usage:
#     * nixos:
#         environment.systemPackages = [
#           (pkgs.supervisedDesktopEntries config.environment.systemPackages)
#         ];
#
#     * home-manager:
#         home.packages = [
#           (pkgs.supervisedDesktopEntries config.home.packages)
#         ];
#
# NOTE: The insertion order of the expression can be arbitrary.

inputPackages: stdenv.mkDerivation rec {
  name = "supervised-desktop-entries";
  # desktopItems = lib.foldl' (x: y: x ++ y) [] (map
  #   (pkg: pkg.desktopItems)
  #   (builtins.filter
  #     (pkg:
  #       (pkg.name != name) &&
  #       (builtins.hasAttr "desktopItems" pkg) &&
  #         ((builtins.length pkg.desktopItems) > 0)
  #     )
  #     inputPackages
  #   )
  # );
  phases = [ "installPhase" ];
  installPhase = let
    packages = builtins.filter (pkg: pkg.name != name) inputPackages;
  in ''
    mkdir $out/share/applications -p
    for desktop in {${lib.concatStringsSep "," (map toString packages)}}/share/applications/*.desktop; do
      sed -E \
        -e 's#^Name=(.*)$#Name=\1 (supervised)#' \
        -e 's#^Exec=(.*)$#Exec=${sdwrap}/bin/sdwrap \1#' \
        $desktop >$out/share/applications/supervised-''${desktop##*/}
    done
  '';

  meta = {
    description = ''
      Generated desktop entries that enable cgroup supervision for applications, desktop file names
      are prefixed with `supervised-`, and desktop entry names are suffixed with `(supervised)`.
    '';
  };
}
