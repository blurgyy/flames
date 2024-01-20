{ openai-whisper-cpp
, cudaPackages
}:

(openai-whisper-cpp.override {
  stdenv = cudaPackages.backendStdenv;
}).overrideAttrs (o: {
  buildInputs = with cudaPackages; o.buildInputs or [] ++ [
    cuda_cccl  # <nv/target>
    cuda_cudart
    cuda_nvcc
    libcublas
  ];
  WHISPER_CUBLAS = 1;

  meta.platforms = [ "x86_64-linux" ];
})
