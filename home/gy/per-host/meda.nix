{ pkgs, ... }: {
  imports = [
    ../parts/gpg-agent.nix
  ];
  home.packages = [
    (pkgs.openai-whisper.override { inherit (pkgs.config) cudaSupport; })
  ];
}
