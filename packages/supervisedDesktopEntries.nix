{ stdenv, lib
, sdwrap
}:

# This is a function for generating desktop entries that wrap the processes of the launched
# application inside a cgroup.  A new desktop entry is generated for each desktop entry that was
# provided by a package with the filename prefixed with `${mark}-` and the entry name suffixed
# with `(${mark})`.
#
#   Usage:
#     * nixos:
#         environment.systemPackages = [
#           (pkgs.supervisedDesktopEntries {
#             inputPackages = config.environment.systemPackages;
#             mark = "supervised";
#           })
#         ];
#
#     * home-manager:
#         home.packages = [
#           (pkgs.supervisedDesktopEntries {
#             inputPackages = config.home.packages;
#             mark = "supervised";
#           })
#         ];
#
# NOTE: The insertion order of the expression can be arbitrary.

{ inputPackages, mark ? "supervised"}: stdenv.mkDerivation rec {
  name = "${mark}-desktop-entries";
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
        -e 's#^Name=(.*)$#Name=\1 (${mark})#' \
        -e 's#^Exec=(.*)$#Exec=${sdwrap}/bin/sdwrap \1#' \
        $desktop >$out/share/applications/${mark}-''${desktop##*/}
      echo "+ $desktop"
    done
  '';

  meta = {
    description = ''
      Generated desktop entries that enable cgroup supervision for applications, desktop file names
      are prefixed with `${mark}-`, and desktop entry names are suffixed with `(${mark})`.
    '';
  };
}
