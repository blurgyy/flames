{ source, lib, buildGoModule }: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-/zDlKW00XCI+TyI4RlCIcehQwkken1+SBpieZhfhpwc=";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/muety/wakapi";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3;
  };
}
