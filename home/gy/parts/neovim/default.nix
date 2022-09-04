{ pkgs }: {
  enable = true;
  package = pkgs.neovim-nightly;

  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  plugins = (with pkgs; [
    lsp-format-nvim
  ]) ++ (with pkgs.vimPlugins; [
    nvim-lspconfig
    null-ls-nvim
    nvim-cmp
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
    bufferline-nvim
    lualine-nvim
      nvim-web-devicons
    todo-comments-nvim
    nvim-tree-lua
    indent-blankline-nvim
    gitsigns-nvim
    # lualine-lsp-progress  # Not tested
    # tabby  # Not provided by nixpkgs

    vim-fugitive
    vim-smoothie
    vim-wakatime
  ]);
  extraConfig = ''
    let g:catppuccin_flavour = "mocha"
    colorscheme catppuccin
    lua <<EOF
    ${builtins.readFile ./config.lua}
    EOF
  '';
  extraPackages = with pkgs; [
    ccls
    clang
    ctags
    pyright
    shfmt
    sumneko-lua-language-server
    taplo-lsp
    texlab
    yaml-language-server
  ];
}
