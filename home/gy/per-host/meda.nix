{ pkgs, ... }: {
  home.packages = [
    (pkgs.openai-whisper.override { inherit (pkgs.config) cudaSupport; })
  ];
}
