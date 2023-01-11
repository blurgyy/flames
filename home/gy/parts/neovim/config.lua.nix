{ config }: let
  inherit (config.ricing.textual) themeColor;
in ''
  vim = vim or {};

  -- Options
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.backspace = "indent,eol,start"
  vim.o.hidden = true

  vim.o.signcolumn = "yes"
  vim.o.completeopt = "menu,menuone,noselect"

  vim.o.errorbells = false
  vim.o.visualbell = true
  vim.api.nvim_set_option("t_vb", "")
  vim.o.shortmess = vim.o.shortmess .. "I"
  vim.o.showmode = false

  vim.o.ignorecase = true
  vim.o.smartcase = true -- This only works when the 'ignorecase' option is on
  vim.o.incsearch = true
  vim.o.inccommand = "split"

  --- Show whitespaces as visible characters if not inside tty
  if os.getenv("TERM") ~= "linux" then
    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    vim.opt.listchars:append("tab:――")
    vim.opt.listchars:append("trail:⋅")
    vim.opt.listchars:append("eol:↴")
  end

  --- Enable undo file and directory
  function exists(file)  -- REF: <https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua>
    local ok, err, code = os.rename(file, file)
    if not ok then
      if code == 13 then
        -- Permission denied, but it exists
        return true
      end
    end
    return ok, err
  end
  function isdir(path)
    return exists(path .. "/")
  end
  if os.getenv("XDG_STATE_HOME") then
    vim.o.undodir = os.getenv("XDG_STATE_HOME") .. "/nvim/undotree"
  else
    vim.o.undodir = os.getenv("HOME") .. "/.local/state/nvim/undotree"
  end
  if not isdir(vim.o.undodir) then
    os.execute("mkdir -p " .. vim.o.undodir)
  end
  vim.o.undofile = true

  vim.o.mouse = "a"

  vim.o.scrolloff = 2

  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true

  vim.g.mapleader = " "
  vim.g.tex_flavor = "latex" -- sets default filetype for .tex files to 'tex', REF: <https://superuser.com/a/676732>

  vim.o.timeoutlen = 500
  vim.o.ttimeout = false -- Disable <Esc> wait time
  vim.o.updatetime = 75

  vim.o.viminfo = "'512,<1024,s512,h"
  vim.o.swapfile = false
  vim.o.backup = false
  vim.o.writebackup = false
  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.softtabstop = -1
  vim.o.expandtab = true

  -- 't' for text auto-wrap (see :h fo-table for full specs)
  vim.o.formatoptions = "croqtnlm2B"

  vim.o.textwidth = 100
  vim.o.colorcolumn = "101"
  vim.o.cursorlineopt = "number"
  vim.o.cursorline = true
  vim.o.showtabline = 2

  vim.o.grepprg = "rg --no-heading --vimgrep"

  vim.o.clipboard = "unnamed,unnamedplus"

  -- Mappings
  local mapping_options = {
    noremap = true,
    silent = true,
  }
  local mappings = {
    n = {
      { name = "Q", target = "<Nop>" },
      { name = "%", target = "v%" },
      { name = "Y", target = "y$" },
      { name = "n", target = "nzz" },
      { name = "N", target = "Nzz" },
      { name = "*", target = "*zz" },
      { name = "#", target = "#zz" },
      { name = "g*", target = "g*zz" },
      { name = "<C-o>", target = "<C-o>zz" },
      { name = "<C-i>", target = "<C-i>zz" },
      { name = "gi", target = "gi<Esc>zzgi" },
      { name = "<C-j>", target = ":m .+1<CR>=kj" },
      { name = "gs", target = ":%s//g<Left><Left>" },
      -- With mapleader
      { name = "<leader>n", target = ":n<CR>" },
      { name = "<leader>N", target = ":N<CR>" },
      { name = "<leader>m", target = ":mode<CR>" },
      { name = "<leader>h", target = ":nohlsearch<CR>" },
      { name = "<leader>;", target = "mPA;<ESC>`P:delmarks P<CR>" },
      { name = "<leader>,", target = "mPA,<ESC>`P:delmarks P<CR>" },
      { name = "<leader>.", target = "mPA.<ESC>`P:delmarks P<CR>" },
      { name = "<leader>tn", target = ":tabnew<CR>" },
      { name = "<leader>tj", target = ":tabmove +<CR>" },
      { name = "<leader>tk", target = ":tabmove -<CR>" },
      {
        name = "<leader>i",
        target = [[:let b:_ = winsaveview()<Bar>:%s/\s\+$//e<Bar>:call winrestview(b:_)<CR>:unlet b:_<CR>]],
      },
      { name = "\\e", target = vim.diagnostic.open_float },
      { name = "[e", target = vim.diagnostic.goto_prev },
      { name = "]e", target = vim.diagnostic.goto_next },
    },
    i = {
    },
    v = {
      { name = "<", target = "<gv" },
      { name = ">", target = ">gv" },
      { name = "=", target = "=gv" },
      { name = "<Tab>", target = ">gv" },
      { name = "<S-Tab>", target = "<gv" },
      { name = "<C-a>", target = "<C-a>gv" },
      { name = "<C-x>", target = "<C-x>gv" },
      { name = "gs", target = ":%s//g<Left><Left>" },
    },
  }
  for mode, map in pairs(mappings) do
    for _, entry in ipairs(map) do
      local options = mapping_options
      if entry.options ~= nil then
        for k, v in pairs(entry.options) do
          options[k] = v
        end
      end
      vim.keymap.set(mode, entry.name, entry.target, options)
    end
  end

  -- vim.api.nvim_set_keymap("n", "Q", '<Nop>', {})

  -- Autocmds
  local lowtab_fts = {
    "context",
    "css",
    "dts",
    "fish",
    "gitcommit",
    "javascript",
    "json",
    "jsonc",
    "latex",
    "lua",
    "markdown",
    "nix",
    "norg",
    "plaintex",
    "sh",
    "sshconfig",
    "tex",
    "toml",
    "vue",
    "yaml",
    "zsh",
  }
  local template = "autocmd FileType %s %s"
  local lowtab_autocmd = string.format(
    template,
    table.concat(lowtab_fts, ","),
    "setlocal tabstop=2 shiftwidth=2\n"
  )

  vim.cmd(lowtab_autocmd)
  vim.cmd([[
    autocmd FileType gitcommit setlocal textwidth=72 colorcolumn=73
    autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"zz' | endif
    " Keybindings for command-line window
    autocmd CmdwinEnter * nnoremap <silent> <ESC> :q<CR>
    autocmd CmdwinLeave * nunmap <ESC>
    autocmd BufEnter * silent filetype detect
    autocmd BufWritePost * silent filetype detect
  ]])

  -- Plugins
  -- catppuccin
  require("catppuccin").setup({
    background = {
      light = "latte",
      dark = "mocha",
    },
  })

  --- lspconfig
  ---- Custom signs
  ---- REF: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#user-content-change-diagnostic-symbols-in-the-sign-column-gutter
  local signs = {
    Error = " ",
    Warn = " ",
    Info = " ",
    Hint = " ",
  }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  ---- REF: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#user-content-change-prefixcharacter-preceding-the-diagnostics-virtual-text
  vim.diagnostic.config({
    virtual_text = {
      prefix = ">",
      source = "if_many",
    },
    float = {
      source = "always",
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
  })

  --- telescope
  local preview_if_not_too_large_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then
        return
      end
      if stat.size > 131072 then -- Do not preview files larger than 128 KB
        return
      else
        require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
  end
  local actions = require("telescope.actions")
  local theme = "ivy"

  -- barbar
  require("bufferline").setup({
    -- Enable/disable animations
    animation = true,

    -- Enable/disable auto-hiding the tab bar when there is a single buffer
    auto_hide = false,

    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,

    -- Enable/disable close button
    closable = true,

    -- Enables/disable clickable tabs
    --  - left-click: go to buffer
    --  - middle-click: delete buffer
    clickable = true,

    -- Enables / disables diagnostic symbols
    diagnostics = {
      -- -- you can use a list
      -- {enabled = true, icon = 'ﬀ'}, -- ERROR
      -- {enabled = false}, -- WARN
      -- {enabled = false}, -- INFO
      -- {enabled = true},  -- HINT

      -- OR `vim.diagnostic.severity`
      [vim.diagnostic.severity.ERROR] = {enabled = true, icon = " "},
      [vim.diagnostic.severity.WARN] = {enabled = true, icon = " "},
      [vim.diagnostic.severity.INFO] = {enabled = true, icon = " "},
      [vim.diagnostic.severity.HINT] = {enabled = true, icon = " "},
    },

    -- Excludes buffers from the tabline
    exclude_ft = {'javascript'},
    exclude_name = {'package.json'},

    -- Hide stuff.  options are `inactive`, `alternate`, `current`, and `visible`.
    hide = {
      extensions = false,
      inactive = false,
      alternate = false,
      visible = false,
    },

    -- Disable highlighting alternate buffers
    highlight_alternate = false,

    -- Enable highlighting visible buffers
    highlight_visible = true,

    -- Enable/disable icons
    -- if set to 'numbers', will show buffer index in the tabline
    -- if set to 'both', will show buffer index and icons in the tabline
    icons = true,

    -- If set, the icon color will follow its corresponding buffer
    -- highlight group. By default, the Buffer*Icon group is linked to the
    -- Buffer* group (see Highlighting below). Otherwise, it will take its
    -- default value as defined by devicons.
    icon_custom_colors = false,

    -- Configure icons on the bufferline.
    icon_separator_active = '▎',
    icon_separator_inactive = '▎',
    icon_close_tab = ' ',
    icon_close_tab_modified = '● ',
    icon_pinned = '車',

    -- If true, new buffers will be inserted at the start/end of the list.
    -- Default is to insert after current buffer.
    insert_at_end = false,
    insert_at_start = false,

    -- Sets the maximum padding width with which to surround each tab
    maximum_padding = 1,

    -- Sets the minimum padding width with which to surround each tab
    minimum_padding = 1,

    -- Sets the maximum buffer name length.
    maximum_length = 30,

    -- If set, the letters for each buffer in buffer-pick mode will be
    -- assigned based on their name. Otherwise or in case all letters are
    -- already assigned, the behavior is to assign letters in order of
    -- usability (see order below)
    semantic_letters = true,

    -- New buffer letters are assigned in this order. This order is
    -- optimal for the qwerty keyboard layout but might need adjustement
    -- for other layouts.
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = nil,
  })
  local opts = { noremap = true, silent = true }
  -- next/prev
  vim.api.nvim_set_keymap("n", "<M-,>", "<Cmd>BufferPrevious<CR>", opts)
  vim.api.nvim_set_keymap("n", "<M-.>", "<Cmd>BufferNext<CR>", opts)
  -- move to next/prev
  vim.api.nvim_set_keymap("n", "<M-<>", "<Cmd>BufferMovePrevious<CR>", opts)
  vim.api.nvim_set_keymap("n", "<M->>", "<Cmd>BufferMoveNext<CR>", opts)
  -- Quick go-to
  vim.api.nvim_set_keymap('n', '<M-1>', '<Cmd>BufferGoto 1<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-2>', '<Cmd>BufferGoto 2<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-3>', '<Cmd>BufferGoto 3<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-4>', '<Cmd>BufferGoto 4<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-5>', '<Cmd>BufferGoto 5<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-6>', '<Cmd>BufferGoto 6<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-7>', '<Cmd>BufferGoto 7<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-8>', '<Cmd>BufferGoto 8<CR>', opts)
  vim.api.nvim_set_keymap('n', '<M-9>', '<Cmd>BufferLast<CR>', opts)
  -- Pick
  vim.api.nvim_set_keymap('n', '<M-p>', '<Cmd>BufferPick<CR>', opts)
  -- Pin/Unpin
  vim.api.nvim_set_keymap('n', '<M-P>', '<Cmd>BufferPin<CR>', opts)
  -- Close buffer
  vim.api.nvim_set_keymap('n', '<M-c>', '<Cmd>BufferClose<CR>', opts)
  
  -- REF: <https://github.com/romgrk/barbar.nvim/#user-content-integration-with-filetree-plugins>
  require("nvim-tree.events").subscribe("TreeOpen", function()
    require("bufferline.api").set_offset(require("nvim-tree.view").View.width)
  end)
  require("nvim-tree.events").subscribe("Resize", function()
    require("bufferline.api").set_offset(require("nvim-tree.view").View.width)
  end)
  require("nvim-tree.events").subscribe("TreeClose", function()
    require("bufferline.api").set_offset(0)
  end)

  -- telescope
  require("telescope").setup({
    defaults = {
      buffer_previewer_maker = preview_if_not_too_large_maker,
      mappings = {
        i = {
          ["<ESC>"] = actions.close,
          ["<C-u>"] = false,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    },
    pickers = {
      buffers              = { theme = theme },
      diagnostics          = { theme = theme },
      find_files           = { theme = theme },
      git_files            = { theme = theme },
      grep_string          = { theme = theme },
      help_tags            = { theme = theme },
      live_grep            = { theme = theme },
      lsp_references       = { theme = theme },
      lsp_type_definitions = { theme = theme },
      treesitter           = { theme = theme },
    }
  })
  local previewer = require("telescope.builtin")
  vim.keymap.set("n", "<C-p>", previewer.find_files, { noremap = true })
  vim.keymap.set("n", "\\g", previewer.git_files, { noremap = true })
  -- Search for a string in cwd and get results as you type
  vim.keymap.set("n", "<leader>g", previewer.live_grep, { noremap = true })
  -- Searches for the string under cursor in cwd
  vim.keymap.set("n", "z*", previewer.grep_string, { noremap = true })
  vim.keymap.set("n", "z#", previewer.grep_string, { noremap = true })
  vim.keymap.set("n", "<leader>b", previewer.buffers, { noremap = true })
  vim.keymap.set("n", "<leader>fh", previewer.help_tags, { noremap = true })
  vim.keymap.set("n", "<leader>v", previewer.treesitter, { noremap = true })
  require("telescope").setup({
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })
  require("telescope").load_extension("fzf")

  --- cmp
  local cmp = require("cmp")
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      {
        name = "path",
        option = {
          get_cwd = function ()
            local buffer_name = vim.api.nvim_buf_get_name(0)
            if buffer_name == nil then
              return vim.fn.getcwd()
            end
            local ret = vim.fn.fnamemodify(buffer_name, ":h")
            if vim.bo.filetype == "tex" then
              local cwd = ret
              while cwd ~= "/" do
                if vim.fn.filereadable(cwd .. "/main.tex") == 1 then
                  ret = cwd
                end
                cwd = vim.fn.fnamemodify(cwd, ":h")
              end
            end
            return ret
          end
        };
      },
      { name = "nvim_lsp_signature_help" },
    }, {
      { name = "buffer" },
    }),
    formatting = {
      format = require("lspkind").cmp_format({
        mode = "symbol",
        preset = "codicons",
      }),
    },
  })
  cmp.setup.cmdline(":", { sources = { { name = "cmdline" } } })
  cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
  cmp.setup.cmdline("?", { sources = { { name = "buffer" } } })
  local caps = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  local enabled_lsps = {
    "bashls",
    "clangd",
    "pyright",
    "nil_ls",
    "rust_analyzer",
    "sumneko_lua",
    "taplo",
    "yamlls",
    "texlab",
  }
  local settings = {
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
          },
        },
      },
    },
    ccls = {
      init_options = {
        cache = {
          directory = "/tmp/ccls",
          format = "binary",
        },
        client = {
          snippetSupport = true,
        },
        compilationDatabaseDirectory = "target",
      },
      root_dir = require("lspconfig").util.root_pattern(
        "target/compile_commands.json",
        ".ccls",
        require("lspconfig").util.find_git_ancestor()
      )
    },
    texlab = {
      formatterLineLength = vim.o.textwidth,
    },
  }
  local opts = { buffer = true, noremap = true, silent = true }
  local navic = require("nvim-navic")
  navic.setup({
    icons = {
      File = ' ',
      Module = ' ',
      Namespace = ' ',
      Package = ' ',
      Class = ' ',
      Method = ' ',
      Property = ' ',
      Field = ' ',
      Constructor = ' ',
      Enum = ' ',
      Interface = ' ',
      Function = ' ',
      Variable = ' ',
      Constant = ' ',
      String = ' ',
      Number = ' ',
      Boolean = ' ',
      Array = ' ',
      Object = ' ',
      Key = ' ',
      Null = ' ',
      EnumMember = ' ',
      Struct = ' ',
      Event = ' ',
      Operator = ' ',
      TypeParameter = ' ',
    },
  })
  local winbar = {
    lualine_b = {
      { navic.get_location, cond = navic.is_available },
    },
    lualine_z = {
      { "filename", cond = function () return vim.bo.buftype ~= "nofile" end }
    },
  }
  require("lualine").setup({
    winbar = winbar,
    inactive_winbar = winbar,
  })
  local on_attach = function(client, bufnr)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-n>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    vim.keymap.set("n", "\\D", previewer.lsp_type_definitions, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>qf", previewer.quickfix, opts)
    vim.keymap.set("n", "gr", previewer.lsp_references, opts)
    vim.keymap.set("n", "<leader>a", previewer.diagnostics, opts)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end
  for _, lspname in pairs(enabled_lsps) do
    local lsp_settings = settings[lspname] or {}
    lsp_settings._name = lspname
    lsp_settings.capabilites = lsp_settings.capabilites or caps
    lsp_settings.on_attach = lsp_settings.on_attach or on_attach
    lsp_settings.root_dir = lsp_settings.root_dir or
        require("lspconfig").util.find_git_ancestor
    lsp_settings.flags = lsp_settings.flags or
        { debounce_text_changes = 150 }
    require("lspconfig")[lspname].setup(lsp_settings)
  end

  --- null-ls
  local null_ls = require("null-ls")
  local h = require("null-ls.helpers")
  local methods = require("null-ls.methods")
  null_ls.setup({
    -- REF: https://github.com/jose-elias-alvarez/null-ls.nvim#user-content-how-do-i-format-files-on-save
    sources = {
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.completion.spell,
      -- null_ls.builtins.formatting.clang_format,
      -- Custom sh/bash/zsh script formatter
      h.make_builtin({
        name = "shfmt",
        meta = {
          url = "https://github.com/mvdan/sh",
          description = "A shell parser, formatter, and interpreter with `bash` support.",
        },
        method = methods.internal.FORMATTING,
        filetypes = { "sh", "bash", "zsh", "PKGBUILD" },
        generator_opts = {
          command = "shfmt",
          args = { "-i", "2", "-filename", "$FILENAME" },
          to_stdin = true,
        },
        factory = h.formatter_factory,
      }),
      -- Custom blackd formatter
      -- REF: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/black.lua
      h.make_builtin({
        name = "blackd",
        meta = {
          url = "https://github.com/psf/black",
          description = "The uncompromising Python code formatter",
        },
        method = methods.internal.FORMATTING,
        filetypes = { "python" },
        generator_opts = {
          command = "curl",
          args = {
            -- Return non-zero when there's any syntax error
            "--fail",
            -- Using "@$FILENAME" below won't work because formatting is
            -- done before writting buffer and at the moment $FILENAME
            -- doesn't contain updated file content. use stdin "@-"
            -- instead.
            "--data-binary", "@-",
            "-H", "X-Line-Length: 100",
            "-H", "X-Skip-Magic-Trailing-Comma: true",
            "localhost:45484",
          },
          to_stdin = true,
        },
        factory = h.formatter_factory,
      }),
    },
  })

  --- lualine
  require("lualine").setup({
    options = {
      section_separators = "",
      component_separators = "|",
    };
    sections = {
      lualine_b = {
        "branch",
        {
          "diagnostics",
          symbols = {
            error = " ", -- From nerd font
            warn = " ", -- From awesome
            info = " ", -- From nerd font
            hint = " ", -- From awesome
          },
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
    },
  })

  -- --- winbar
  -- require("winbar").setup({
  --   enabled = true,
  --   show_file_path = true,
  --   show_symbols = true,
  -- })

  --- nvim-tree
  require("nvim-tree").setup({
    renderer = {
      icons = {
        glyphs = {
          git = {
            deleted = "✘",
            renamed = "➜",
            staged = "⇡",
            unstaged = "!",
            untracked = "*",
          },
          folder = {
            symlink = "",
            symlink_open = "",
          },
        },
      },
    },
    view = {
      mappings = {
        custom_only = false,
        list = {
          ---- REF: `:h nvim-tree-mappings`
          ---- Remove default undesired mapping with empty string
          { key = "H", action = "" },
          ---- Custom mappings
          { key = "l", action = function()
            local lib = require("nvim-tree.lib")
            local view = require("nvim-tree.view")
            ---- open as vsplit on current node
            local action = "edit"
            local node = lib.get_node_at_cursor()
            ---- Just copy what's done normally with vsplit
            if node.link_to and not node.nodes then
              require('nvim-tree.actions.open-file').fn(action, node.link_to)
              view.close() -- Close the tree if file was opened
            elseif node.nodes ~= nil then
              lib.expand_or_collapse(node)
            else
              require('nvim-tree.actions.open-file').fn(action, node.absolute_path)
              view.close() -- Close the tree if file was opened
            end
          end, },
          { key = "h", action = "close_node", },
          { key = "zh", action = "toggle_dotfiles", },
          { key = "zi", action = "toggle_git_ignored", },
          { key = "t", action = "tabnew" },
          { key = "gy", action = "copy_absolute_path" },
          { key = "dd", action = "cut" },
          { key = "yy", action = "copy" },
          { key = "Y", action = "copy_name" },
          { key = "p", action = "paste" }
        },
      },
    },
    update_focused_file = { enable = true },
    diagnostics = { enable = true },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  })
  vim.keymap.set("n", "<leader>d", "<CMD>NvimTreeToggle<CR>", { silent = true, noremap = true })
  ---- REF: https://github.com/kyazdani42/nvim-tree.lua#tips--reminders
  vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

  --- gitsigns
  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "#" },
      delete = { text = "-" },
    },
    current_line_blame = false,
  })
  local opts = { noremap = true, silent = true }
  vim.keymap.set("", [[\h]], "<CMD>Gitsigns preview_hunk<CR>", opts)
  vim.keymap.set("", "[h", "<CMD>Gitsigns prev_hunk<CR>", opts)
  vim.keymap.set("", "]h", "<CMD>Gitsigns next_hunk<CR>", opts)
  vim.keymap.set("", "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", opts)
  -- TODO: Deprecate this after the feature mentioned in <https://github.com/lewis6991/gitsigns.nvim/issues/510> is implemented
  vim.keymap.set("n", "<leader>hu", "<CMD>Gitsigns reset_hunk<CR>", opts)
  vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns toggle_current_line_blame<CR>", opts)

  --- treesitter, ts-rainbow
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      ---- disable = { "help", "html" },
    },
    incremental_selection = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    -- REF: https://github.com/p00f/nvim-ts-rainbow#user-content-setup
    rainbow = {
      enable = true,
      extended_mode = true, -- Highlight also non-parentheses delimiters, like html tags, boolean or table: lang -> boolean
      colors = {
        "${themeColor "yellow"}",
        "${themeColor "blue"}",
        "${themeColor "highlight"}",
        "${themeColor "purple"}",
        "${themeColor "red"}",
      },
    },
  })
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  vim.o.foldenable = false ---- After changing this, run :PackerCompile to take effect

  --- indent-blankline
  require("indent_blankline").setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  })

  -- todo-comments
  require("todo-comments").setup({
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    ---- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        ---- signs = false, -- configure signs for some keywords individually
      },
      DONE = { icon = " " --[[ from vscode-codicon]] , color = "info" },
      DOING = { icon = " ", color = "info" },
      TODO = { icon = " " --[[ from vscode-codicon ]] , color = "default" },
      HACK = { icon = " ", color = "warning" },
      CAVEAT = { icon = " " --[[ from vscode-codicon ]] ,
        color = "warning", alt = { "WARN", "WARNING" } },
      PERF = { icon = " ", alt = { "OPT", "OPTIMIZE", "PERF", "PERFORMANCE" } },
      NOTE = { icon = " " --[[ from vscode-codicon ]] ,
        color = "hint", alt = { "INFO", "HINT" } },
      REF = { icon = " " --[[ from vscode-codicon ]] ,
        color = "default" },
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    ---- highlighting of the line containing the todo comment
    ---- * before: highlights before the keyword (typically comment characters)
    ---- * keyword: highlights of the keyword
    ---- * after: highlights after the keyword (todo text)
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    ---- list of named colors where we try to extract the guifg from the list of
    ---- highlight groups or use the hex color if hl not found as a fallback
    colors = {
      -- error = { "#bf616a" }, -- nord11 (red)
      -- warning = { "#d08770" }, -- nord12 (orange)
      -- hint = { "#ebcb8b" }, -- nord13 (yellow)
      -- info = { "#a3be8c" }, -- nord14 (green)
      -- default = { "#b48ead" }, -- nord15 (purple)
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      ---- regex that will be used to match keywords.
      ---- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      ---- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  })

  -- Neorg
  require("neorg").setup({
    load = {
      -- Enable all default modules
      ["core.defaults"] = {},
      ["core.norg.concealer"] = {},
      -- ["core.norg.completion"] = {},
      ---- Export to markdown via command `:Neorg export to-file <name>.md`
      --["core.export"] = {},
      --["core.export.markdown"] = {
      --  config = {
      --    extensions = "all";
      --  },
      --},
    },
  })

  -- fcitx5-ui
  local lualine_cfg = require("lualine").get_config()
  local function get_im()
    local mapping = {
      [""] = " ",
      ["keyboard-us"] = " ",
      ["pinyin"] = "中",
    }
    return mapping[require("fcitx5-ui").getCurrentIM()]
  end
  if not GET_IM_INSERTED then
    table.insert(lualine_cfg.sections.lualine_y, get_im)
    GET_IM_INSERTED = true
  end
  require("lualine").setup(lualine_cfg)
  vim.keymap.set({ "i", "n" }, [[<C-\>]], function()
    require("fcitx5-ui").toggle()
    return "<Ignore>"
  end, { buffer = true, expr = true })

  -- comment.nvim
  require("Comment").setup()

  ----- gutentags
  ------ Project root patterns
  --vim.g.gutentags_project_root = { ".git", "Makefile", ".thisisroot" }
  ------ Name of generated data file
  --vim.g.gutentags_ctags_tagfile = ".tags"
  ------ Move all generated data file to ~/.local/state/nvim/gutentags
  if os.getenv("XDG_STATE_HOME") then
    vim.g.gutentags_cache_dir = os.getenv("XDG_STATE_HOME") .. "/nvim/gutentags"
  else
    vim.o.gutentags_cache_dir = os.getenv("HOME") .. "/.local/state/nvim/gutentags"
  end
  ------ Ctags parameters yanked from: https://www.zhihu.com/question/47691414
  --vim.g.gutentags_ctags_extra_args = {
  --  "--fields=+nialmzS",
  --  "--extra=+q",
  --  "--guess-language-eagerly",
  --  "--kinds-c++=+px",
  --  "--kinds-c=+px",
  --}
  ------ Generate tags in most cases
  --vim.g.gutentags_generate_on_new = true
  --vim.g.gutentags_generate_on_missing = true
  --vim.g.gutentags_generate_on_write = true
  --vim.g.gutentags_generate_on_empty_buffer = false
  ------ Create cache directory if it does not exist
  --os.execute("mkdir -p " .. vim_tags)
  ------ Ignore files properly
  --vim.g.gutentags_file_list_command = "rg --files --hidden --ignore-files -g\"!.git/\""

  ----- nvim-comment
  --require("nvim_comment").setup({
  --  comment_empty = false,
  --  line_mapping = "<C-_>",
  --})
''
