{ source, lib, vimUtils }: vimUtils.buildVimPluginFrom2Nix {
  inherit (source) pname version src;

  meta = {
    homepage = "https://github.com/SmiteshP/nvim-navic";
    description = "Simple winbar/statusline plugin that shows your current code context";
    license = lib.licenses.asl20;
  };
}
