{ source, lib, buildGoModule
, fuse
}: buildGoModule {
  inherit (source) pname version src;
  vendorHash = "sha256-lZIM1Cy3JmcrnxC+HN9Ni7P70yVR1LtHVKe3nOhA4fg=";

  buildInputs = [ fuse ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/alist-org/alist";
    description = "A file list program that supports multiple storage, powered by Gin and Solidjs. / 一个支持多存储的文件列表程序，使用 Gin 和 Solidjs。";
    license = lib.licenses.agpl3Plus;
  };
}
