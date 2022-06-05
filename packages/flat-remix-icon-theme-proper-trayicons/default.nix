{ flat-remix-icon-theme }:
flat-remix-icon-theme.overrideAttrs (oldAttrs: {
  pname = "flat-remix-icon-theme-proper-trayicons";
  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/
    for theme in $out/share/icons/*; do
      if [[ -d "$theme/panel" ]]; then
        pushd "$theme/panel"
        for icon in *-tray.*; do
          ln -s $icon $(sed -E 's/-tray\././' <<<"$icon") || true
        done
        popd
      fi
      gtk-update-icon-cache $theme
    done
  '';
  dontFixup = true;
})
