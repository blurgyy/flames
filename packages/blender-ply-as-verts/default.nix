{ lib
, blender
, import-ply-as-verts-for-blender
}: with lib; blender.overrideAttrs (o: {
  postInstall = ''
    cp -v ${import-ply-as-verts-for-blender}/share/import-ply-as-verts/{__init__,import_ply}.py \
      $out/share/blender/${
        concatStringsSep "." (take 2 (splitVersion o.version))
      }/scripts/addons/io_mesh_ply
  '';
})
