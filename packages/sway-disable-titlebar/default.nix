{ sway-unwrapped }:

sway-unwrapped.overrideAttrs (o: {
  patches = o.patches or [] ++ [
    ./allow-zero-font-size-in-tab-bar.patch
  ];
})
