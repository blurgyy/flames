{ source, lib, vimUtils }: vimUtils.buildVimPlugin {
  inherit (source) pname version src;
  meta = {
    homepage = "https://github.com/pmizio/typescript-tools.nvim";
    description = "TypeScript integration NeoVim deserves";
    license = lib.licenses.mit;
  };
}
