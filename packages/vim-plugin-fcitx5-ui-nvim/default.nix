{ generated, source, lib, vimUtils
, lua51Packages
}: let
  dbus_proxy = lua51Packages.buildLuarocksPackage rec {
    inherit (generated."luarock-dbus_proxy") pname version src;
    knownRockspec = "${src}/rockspec/dbus_proxy-0.10.3-1.rockspec";
    propagatedBuildInputs = with lua51Packages; [ lgi ];
    meta = {
      homepage = "https://github.com/stefano-m/lua-dbus_proxy";
      description = "Simple API around GLib's GIO:GDBusProxy built on top of lgi";
      license = lib.licenses.asl20;
    };
  };
in vimUtils.buildVimPluginFrom2Nix {
  inherit (source) pname version src;
  propagatedBuildInputs = [ lua51Packages.lgi dbus_proxy ];
  postPatch = let
    luaVersion = with lib; concatStringsSep "." (take 2 (splitVersion lua51Packages.lua.version));
  in ''
    sed -Ee '1ipackage.cpath = "${lua51Packages.lgi}/lib/lua/${luaVersion}/?.so;" .. package.cpath' \
        -e '1ipackage.path = "${lua51Packages.lgi}/share/lua/${luaVersion}/?.lua;" .. package.path' \
        -e '1ipackage.path = "${lua51Packages.lgi}/share/lua/${luaVersion}/?/init.lua;" .. package.path' \
        -e '1ipackage.path = "${dbus_proxy}/share/lua/${luaVersion}/?.lua;" .. package.path' \
        -e '1ipackage.path = "${dbus_proxy}/share/lua/${luaVersion}/?/init.lua;" .. package.path' \
        -i lua/fcitx5-ui/utils.lua
  '';
  meta = {
    homepage = "https://github.com/black-desk/fcitx5-ui.nvim";
    description = "fcitx5 user interface inside neovim";
    license = lib.licenses.gpl3;
  };
}
