{ zellij, source }: zellij.overrideAttrs (oldAttrs: {
  pname = "zellij-hirr";
  inherit (source) version;
  patches = oldAttrs.patches ++ [
    ./0001-use-shorter-render_pause.patch
  ];
  meta.description = oldAttrs.meta.description + " (with refresh rate boosted to 3ms/frame)";
  meta.mainProgram = "zellij";
})
