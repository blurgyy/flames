{ source, lib, luaPackages }: luaPackages.buildLuarocksPackage rec {
  inherit (source) pname version src;
  knownRockspec = "${src}/rockspec/dbus_proxy-0.10.3-1.rockspec";
  buildInputs = with luaPackages; [ lgi ];
  meta = {
    homepage = "https://github.com/stefano-m/lua-dbus_proxy";
    description = "Simple API around GLib's GIO:GDBusProxy built on top of lgi";
    license = lib.licenses.asl20;
  };
}
