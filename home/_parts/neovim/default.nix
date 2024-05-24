{ config, lib, pkgs, callWithHelpers }: rec {
  enable = true;

  withNodeJs = true;

  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;

  plugins = with pkgs.vimPlugins; [
    pkgs.vim-plugin-bigfile-nvim
    pkgs.vim-plugin-rainbow-delimiters-nvim
    pkgs.vim-plugin-typescript-tools-nvim

    flash-nvim
    nvim-colorizer-lua
    vim-illuminate
    copilot-lua
    nvim-lspconfig
    lsp_signature-nvim
    null-ls-nvim
    nvim-cmp
    nvim-navic
    luasnip
      copilot-cmp
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
        bash
        bibtex
        c
        cmake
        cpp
        css
        cuda
        elm
        fish
        html
        javascript
        json
        jsonc
        kdl
        latex
        lua
        make
        markdown
        ninja
        nix
        norg
        php
        python
        r
        rust
        scss
        sql
        svelte
        toml
        typescript
        typst
        tsx
        yaml
        yuck
        vim
        vue
      ]
    ))
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
  ] ++ lib.optional (config.home.username != "root") vim-wakatime;
  extraConfig = ''
    lua <<EOF
    ${callWithHelpers ./config.lua.nix {}}
    EOF
    colorscheme catppuccin
  '' + lib.optionalString (builtins.elem pkgs.vimPlugins.copilot-lua plugins) ''
    " let's disable copilot by default
    autocmd VimEnter * :Copilot disable
  '';
  extraPackages = with pkgs; [
    cargo
    ccls
    clang-tools
    ctags
    elmPackages.elm-language-server
    go
    gopls
    nil
    pyright
    shfmt
    nodePackages.svelte-language-server
    lua-language-server
    rustc  # provides source code of rust standard library for completion
    rust-analyzer
    tailwindcss-language-server
    taplo-lsp
    texlab
    typst-lsp
    yaml-language-server
    vscode-langservers-extracted
  ] ++ lib.optional (config.home.username != "root") wakatime;
}
