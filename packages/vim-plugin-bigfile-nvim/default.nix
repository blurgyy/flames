{ source, lib, vimUtils }: vimUtils.buildVimPlugin {
  inherit (source) pname version src;
  meta = {
    homepage = "https://github.com/LunarVim/bigfile.nvim";
    description = "Make editing big files faster 🚀";
    license = lib.licenses.asl20;
  };
}
