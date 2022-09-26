{ symlinkJoin, stdenv
, v2ray
, loyalsoldier-geodata
}: v2ray.overrideAttrs (oldAttrs: {
  pname = "v2ray-loyalsoldier";
  buildCommand = ''
    for file in ${v2ray}/bin/*; do
      makeWrapper "$file" "$out/bin/$(basename "$file")" \
        --suffix XDG_DATA_DIRS : ${loyalsoldier-geodata}/share
    done
  '';
})
