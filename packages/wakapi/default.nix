{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-+FYeaIQXHZyrik/9OICl2zk+OA8X9bry7JCQbdf9QGs=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
