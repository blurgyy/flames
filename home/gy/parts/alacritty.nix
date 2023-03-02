{ config }: {
  env = {
    TERM = "xterm-256color";
  };
  window = {
    decorations = "full";
    startup_mode = "Maximized";
    title = "Alacritty";
    decorations_theme_variant = null;
  };

  font = {
    normal = {
      family = "monospace";
    };
    bold = {
      family = "monospace";
      style = "Bold";
    };
    italic = {
      family = "monospace";
      style = "Italic";
    };
    bold_italic = {
      family = "monospace";
      style = "Bold Italic";
    };
    size = 15;
  };

  # colorscheme is handled in ricing.nix
  colors.transparent_background_colors = true;

  window.opacity = 1;
}
