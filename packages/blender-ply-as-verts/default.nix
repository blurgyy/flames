{ generated, lib
, blender
}: with lib; blender.overrideAttrs (o: {
  pname = o.pname + "-import-ply-as-verts";
  postInstall = o.postInstall or "" + ''
    install -Dvm444 -t \
      $out/share/blender/${concatStringsSep "." (take 2 (splitVersion o.version))}/scripts/addons/io_mesh_ply \
      ${generated.import-ply-as-verts-for-blender.src}/Blender_Files/{__init__,import_ply}.py
  '';
})
