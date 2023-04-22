{ source, lib, vimUtils }: vimUtils.buildVimPluginFrom2Nix {
  inherit (source) pname version src;
  meta = {
    homepage = "https://github.com/LunarVim/bigfile.nvim";
    description = "Make editing big files faster 🚀";
    license = lib.licenses.asl20;
  };
}
