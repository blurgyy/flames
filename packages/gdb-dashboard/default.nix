{ source, lib, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;
  buildCommand = ''
    install -Dvm644 $src/.gdbinit $out/share/gdb-dashboard/gdbinit
  '';
  meta = {
    homepage = "https://github.com/cyrus-and/gdb-dashboard";
    description = "Modular visual interface for GDB in Python";
    license = lib.licenses.mit;
  };
}
