{ ... }: {
  imports = [
    ./ollama.nix
    ./machine-status.nix
    ./rclone
  ];
}
