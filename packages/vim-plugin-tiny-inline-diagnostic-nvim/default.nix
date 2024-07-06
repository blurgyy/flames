{ source, lib, vimUtils }:

vimUtils.buildVimPlugin {
  inherit (source) pname version src;
  meta = {
    homepage = "https://github.com/rachartier/tiny-inline-diagnostic.nvim";
    description = ''
      A Neovim plugin that display prettier diagnostic messages. Display one line diagnostic
      messages where the cursor is, with icons and colors.
    '';
    license = lib.licenses.mit;
  };
}
