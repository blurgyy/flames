{ openai-whisper-cpp, symlinkJoin
, gcc11Stdenv
, cudatoolkit
}:

let
  cudatoolkit-unsplit = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.lib cudatoolkit.out ];
  };
  openai-whisper-cpp-gcc11 = openai-whisper-cpp.override {
    stdenv = gcc11Stdenv;
  };
in

openai-whisper-cpp-gcc11.overrideAttrs (o: {
  propagatedBuildInputs = o.propagatedBuildInputs or [] ++ [
    cudatoolkit-unsplit
  ];
  WHISPER_CUBLAS = 1;

  meta.platforms = [ "x86_64-linux" ];
})
