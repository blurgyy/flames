{ generated, lib
, blender
}: with lib; (blender.override { cudaSupport = true; }).overrideAttrs (o: {
  pname = o.pname + "-import-ply-as-verts-cuda";

  # nvcc from cudatoolkit at nixpkgs/23.05 does not support sm_89
  postPatch = ''
    sed -Ee 's/ sm_89 / /g' -i CMakeLists.txt
  '';

  postInstall = o.postInstall or "" + ''
    install -Dvm444 -t \
      $out/share/blender/${concatStringsSep "." (take 2 (splitVersion o.version))}/scripts/addons/io_mesh_ply \
      ${generated.import-ply-as-verts-for-blender.src}/Blender_Files/{__init__,import_ply}.py
  '';
  meta.platforms = [ "x86_64-linux" ];
})
