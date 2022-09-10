{ source, stdenv }: stdenv.mkDerivation {
  inherit (source) pname version src;

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share/import-ply-as-verts
    cp -v $src/Blender_Files/{__init__,import_ply}.py $out/share/import-ply-as-verts
  '';

  meta = {
    homepage = "https://github.com/TombstoneTumbleweedArt/import-ply-as-verts";
    description = "New Blender 3.0* / 3.1 PLY importer v2.0 for point clouds and nonstandard models.";
  };
}
