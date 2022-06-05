{ prev, vimUtils, fetchFromGitHub }:
vimUtils.buildVimPluginFrom2Nix rec {
  name = "lsp-format-nvim";
  version = "v2.3.3";
  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = "lsp-format.nvim";
    rev = "refs/tags/${version}";
    sha256 = "sha256-LSmhW2gj+3W4KiFmqw2qrEyzVwugcRmTd/qPRZwRiQU=";
  };
  meta.homepage = "https://github.com/lukas-reineke/lsp-format.nvim";
}
