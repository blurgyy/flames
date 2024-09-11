{ source, lib, buildGoModule
, fuse
}: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-+7CMubbCrl+DsGmN9/2jCQ6zLDKvjJ6PdJx8iI1vKOQ=";

  meta = {
    homepage = "https://github.com/aceberg/WatchYourLAN";
    description = "Lightweight network IP scanner. Can be used to notify about new hosts and monitor host online/offline history";
    license = lib.licenses.mit;
  };
}
