{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-SqkE4vTT+QoLhKrQcGa2L5WmD+fCX7vli4FjgwLnqjg=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
