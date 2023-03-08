{ source, lib, tmuxPlugins }: tmuxPlugins.mkTmuxPlugin {
  inherit (source) version src;
  pluginName = source.pname;
  rtpFilePath = "catppuccin.tmux";
  patches = [
    ./customize-status-right.patch
  ];
  meta = {
    homepage = "https://github.com/catppuccin/tmux";
    license = lib.licenses.mit;
    description = "Soothing pastel theme for Tmux";
  };
}
