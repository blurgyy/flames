{ zellij, fetchpatch }:
zellij.overrideAttrs (oldAttrs: {
  pname = "zellij-hirr";
  patches = oldAttrs.patches ++ [
    ./0001-use-shorter-render_pause.patch
  ];
  meta.mainProgram = "zellij";
})
