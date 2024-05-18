{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-Kt7RzAGZeLFhwvq+V6AK88rivqkoTE1Zep7NMh3BXXQ=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3;
  };
}
