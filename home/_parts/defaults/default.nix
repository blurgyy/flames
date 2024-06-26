{ hostName, ... }: {
  imports = [
    ./configuration.nix
    ./secrets.nix
  ];

  home.presets = {
    development = builtins.elem hostName [
      "morty"
      "winston"
      "mono"
      "vdm0"
    ];
    entertainment = builtins.elem hostName [
      "morty"
    ];
    recreation = builtins.elem hostName [
      "morty"
      "rpi"
      "vdm0"
      "winston"
    ];
    scientific = builtins.elem hostName [
      "morty"
      "vdm0"
      "winston"
    ];
    sans-systemd = builtins.elem hostName [
      "vdm0"
    ];
  };
}
