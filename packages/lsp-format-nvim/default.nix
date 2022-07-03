{ source, vimUtils }:
vimUtils.buildVimPluginFrom2Nix rec {
  inherit (source) pname version src;
  meta.homepage = "https://github.com/lukas-reineke/lsp-format.nvim";
}
