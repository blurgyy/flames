{ source, lib, tmuxPlugins }: tmuxPlugins.mkTmuxPlugin {
  inherit (source) version src;
  pluginName = source.pname;
  rtpFilePath = "catppuccin.tmux";
  meta = {
    homepage = "https://github.com/catppuccin/tmux";
    licence = lib.licenses.mit;
    description = "Soothing pastel theme for Tmux";
  };
}
