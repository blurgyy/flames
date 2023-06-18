{ generated, lib
, blender
}: with lib; blender.overrideAttrs (o: {
  pname = o.pname + "-import-ply-as-verts";
  buildCommand = ''
    set -euo pipefail
    ${  # REF: <https://stackoverflow.com/a/68523368/13482274>
      lib.concatStringsSep "\n" (map (outputName: ''
        echo "Copying output ${outputName}"
        set -x
        cp -rs --no-preserve=mode "${blender.${outputName}}" "''$${outputName}"
        set +x
      '')
      (o.outputs or ["out"]))
    }

    install -Dvm444 -t \
      $out/share/blender/${concatStringsSep "." (take 2 (splitVersion o.version))}/scripts/addons/io_mesh_ply \
      ${generated.import-ply-as-verts-for-blender.src}/Blender_Files/{__init__,import_ply}.py
  '';
})
