{ waybar }: waybar.overrideAttrs (o: {
  mesonFlags = o.mesonFlags ++ [ "-Dexperimental=true" ];
})
