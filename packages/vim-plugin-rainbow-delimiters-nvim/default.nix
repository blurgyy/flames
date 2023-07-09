{ source, lib, vimUtils }: vimUtils.buildVimPluginFrom2Nix {
  inherit (source) pname version src;
  meta = {
    homepage = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim";
    description = "Rainbow delimiters for Neovim with Tree-sitter";
    license = lib.licenses.asl20;
  };
}
