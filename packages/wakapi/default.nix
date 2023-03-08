{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorSha256 = "sha256-sfx8qlmJrS0hkD6DSvKqfnBDbxj8eNA3hnprSwA2fSI=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics ";
    license = lib.licenses.gpl3;
  };
}
