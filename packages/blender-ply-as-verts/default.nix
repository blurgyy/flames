{ config, generated, lib
, blender
, unzip
, cudaSupport ? config.cudaSupport
}:

with lib;

(blender.override { inherit cudaSupport; }).overrideAttrs (o: {
  pname = o.pname + "-import-ply-as-verts" + (if cudaSupport then "-cuda" else "");

  buildInputs = o.buildInputs or [] ++ [ unzip ];

  # nvcc from cudatoolkit at nixpkgs/23.05 does not support sm_89
  postPatch = o.postPatch or "" + ''
    sed -Ee 's/ sm_89 / /g' -i CMakeLists.txt
  '';

  postInstall = o.postInstall or "" + ''
    unzip ${generated.import-ply-as-verts-for-blender.src}/Import_PLY_as_Verts_3.zip
    unzip PLY_As_Verts.zip

    install -Dvm444 -t \
      $out/share/blender/${concatStringsSep "." (take 2 (splitVersion o.version))}/scripts/addons/io_mesh_ply \
      Addon-Build/{__init__,{ex,im}port_ply}.py
  '';

  meta.platforms = [ "x86_64-linux" ];
})
