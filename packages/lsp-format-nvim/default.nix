{ prev, vimUtils, fetchFromGitHub }:
vimUtils.buildVimPluginFrom2Nix rec {
  name = "lsp-format-nvim";
  version = "v2.4.1";
  src = fetchFromGitHub {
    owner = "lukas-reineke";
    repo = "lsp-format.nvim";
    rev = "refs/tags/${version}";
    sha256 = "sha256-xFA+9JO3Rnj/CAYXb+oOnbslH3jgEapHA67I6dMFRFI=";
  };
  meta.homepage = "https://github.com/lukas-reineke/lsp-format.nvim";
}
