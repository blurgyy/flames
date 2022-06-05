{ zellij, fetchpatch }:
zellij.overrideAttrs (oldAttrs: {
  pname = "zellij-hirr";
  patches = oldAttrs.patches ++ [
    ./0001-use-shorter-render_pause.patch
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/zellij-org/zellij/pull/1375.patch";
      sha256 = "sha256-+yPaDc010Z4nHf/qdZda0W922J1d1kYIjfVj+i/7r+A=";
    })
  ];
})
