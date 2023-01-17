{ config, pkgs, callWithHelpers }: {
  enable = true;

  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  plugins = with pkgs.vimPlugins; [
    pkgs.vim-plugin-fcitx5-ui-nvim  # NOTE: Must configure fcitx5 with `ShareInputState=no` (see ../../parts/mirrored/fcitx5/config

    comment-nvim
    nvim-lspconfig
    null-ls-nvim
    nvim-cmp
    nvim-navic
    luasnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-document-symbol
      cmp_luasnip
      lspkind-nvim
    cmp-nvim-lsp
    telescope-nvim
      telescope-fzf-native-nvim
    (nvim-treesitter.withPlugins (
      plugins: with plugins; [
        tree-sitter-bash
        tree-sitter-bibtex
        tree-sitter-c
        tree-sitter-cmake
        tree-sitter-cpp
        tree-sitter-css
        tree-sitter-cuda
        tree-sitter-elm
        tree-sitter-fish
        # tree-sitter-help  # Not provided by nixpkgs
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-json
        # tree-sitter-jsonc  # Not provided by nixpkgs
        tree-sitter-latex
        tree-sitter-lua
        tree-sitter-make
        tree-sitter-markdown
        # tree-sitter-ninja  # Not provided by nixpkgs
        tree-sitter-nix
        tree-sitter-norg
        tree-sitter-php
        tree-sitter-python
        tree-sitter-r
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-yaml
        tree-sitter-vim
        tree-sitter-vue
      ]
    ))
      nvim-ts-rainbow
    neorg
    catppuccin-nvim
    barbar-nvim
    lualine-nvim
      nvim-web-devicons
    todo-comments-nvim
    nvim-tree-lua
    indent-blankline-nvim
    gitsigns-nvim
    # lualine-lsp-progress  # Not tested
    # tabby  # Not provided by nixpkgs

    vim-cool
    vim-fugitive
    vim-smoothie
    vim-wakatime
  ];
  extraConfig = ''
    lua <<EOF
    ${callWithHelpers ./config.lua.nix {}}
    EOF
    colorscheme catppuccin
    set background=${config.ricing.textual.theme}
  '';
  extraPackages = with pkgs; [
    ccls
    clang-tools
    ctags
    elmPackages.elm-language-server
    nil
    pyright
    shfmt
    sumneko-lua-language-server
    taplo-lsp
    texlab
    yaml-language-server
  ];
}
