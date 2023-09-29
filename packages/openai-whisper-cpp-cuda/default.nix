{ openai-whisper-cpp, symlinkJoin
, cudatoolkit
}:

let
  cudatoolkit-unsplit = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.lib cudatoolkit.out ];
  };
in

openai-whisper-cpp.overrideAttrs (o: {
  propagatedBuildInputs = o.propagatedBuildInputs or [] ++ [
    cudatoolkit-unsplit
  ];
  WHISPER_CUBLAS = 1;

  meta.platforms = [ "x86_64-linux" ];
})
