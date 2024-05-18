{ config }: let
  inherit (config.ricing) themeColor;
in ''
  vim = vim or {};
  table.unpack = table.unpack or unpack

  -- Options
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.backspace = "indent,eol,start"
  vim.o.hidden = true

  vim.o.signcolumn = "yes"
  vim.o.completeopt = "menu,menuone,noselect"

  vim.o.errorbells = false
  vim.o.visualbell = true
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

    --- indent-blankline
    require("ibl").setup({
      whitespace = {
        remove_blankline_trail = true,
      },
      indent = {
        char = "▏",
      },
    })
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
  local function prequire(m)   -- REF: <https://stackoverflow.com/a/17878208/13482274>
    local ok, err = pcall(require, m)
    if not ok then return nil, err end
    return err
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
  vim.o.cursorlineopt = "both"  -- equivalent as "line,number"
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
      { name = "<M-CR>", target = ":lua vim.lsp.buf.code_action()<CR>" },
      -- With mapleader
      { name = "<leader>n", target = ":n<CR>" },
      { name = "<leader>N", target = ":N<CR>" },
      { name = "<leader>m", target = ":mode<CR>" },
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
      { name = "ge", target = vim.diagnostic.open_float },
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
  -- NOTE: mappings are set on BufEnter, implemented at last

  -- Autocmds
  local lowtab_fts = {
    "context",
    "css",
    "dts",
    "fish",
    "gitcommit",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "latex",
    "lua",
    "markdown",
    "nix",
    "norg",
    "plaintex",
    "sass",
    "scss",
    "sh",
    "sql",
    "sshconfig",
    "tex",
    "toml",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
    "yaml",
    "zsh",
  }
  local template = "autocmd FileType %s %s"
  local lowtab_autocmd = string.format(
    template,
    table.concat(lowtab_fts, ","),
    "setlocal tabstop=2 softtabstop=2 shiftwidth=2\n"
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
    " avoid :edit or buffer switching from setting the line of cursor to center
    autocmd BufLeave * let b:__bufview=winsaveview()
    autocmd BufEnter * if exists('b:__bufview') | call winrestview(b:__bufview) | endif
  ]])

  -- Plugins
  -- flash.nvim
  require("flash").setup({})

  -- catppuccin
  require("catppuccin").setup({
    -- REF: <https://github.com/catppuccin/nvim#user-content-config>
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    background = {
      light = "latte",
      dark = "mocha",
    },
  })

  --- typescript-tools
  require('typescript-tools').setup({})

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
      -- REF: <https://neovim.io/doc/user/api.html#nvim_open_win()>
      -- none/single/double/rounded/solid/shadow
      border = "double",
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
  })

  --- lsp_signature
  local lsp_signature_cfg = {
    hint_prefix = "(param) ",
    -- needs neovim 0.10+
    -- hint_inline = function() return true end,
  }
  require("lsp_signature").setup(lsp_signature_cfg)

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
    icons = {
      filetype = {
        enabled = true,
      },
      inactive = {
        separator = {
          left = '⎸',
        },
      },
      separator = {
        left = '▎',
      },
      button = ' ',
      modified = {
        button = '● ',
      },
      pinned = {
        button = '車',
      },
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
    },

    -- If set, the icon color will follow its corresponding buffer
    -- highlight group. By default, the Buffer*Icon group is linked to the
    -- Buffer* group (see Highlighting below). Otherwise, it will take its
    -- default value as defined by devicons.
    icon_custom_colors = false,

    -- Configure icons on the bufferline.

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
    -- optimal for the qwerty keyboard layout but might need adjustment
    -- for other layouts.
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
    -- where X is the buffer number. But only a static string is accepted here.
    no_name_title = nil,
  })
  local opts = { noremap = true, silent = true }
  -- keymaps for barbar
  mappings.n = {
    -- next/prev
    { name = "<M-,>", target = "<CMD>BufferPrevious<CR>" },
    { name = "<M-.>", target = "<CMD>BufferNext<CR>" },
    -- move to next/prev
    { name = "<M-<>", target = "<CMD>BufferMovePrevious<CR>" },
    { name = "<M->>", target = "<CMD>BufferMoveNext<CR>" },
    -- Quick go-to
    { name = "<M-1>", target = "<CMD>BufferGoto 1<CR>" },
    { name = "<M-2>", target = "<CMD>BufferGoto 2<CR>" },
    { name = "<M-3>", target = "<CMD>BufferGoto 3<CR>" },
    { name = "<M-4>", target = "<CMD>BufferGoto 4<CR>" },
    { name = "<M-5>", target = "<CMD>BufferGoto 5<CR>" },
    { name = "<M-6>", target = "<CMD>BufferGoto 6<CR>" },
    { name = "<M-7>", target = "<CMD>BufferGoto 7<CR>" },
    { name = "<M-8>", target = "<CMD>BufferGoto 8<CR>" },
    { name = "<M-9>", target = "<CMD>BufferLast<CR>" },
    -- Pick
    { name = "<M-p>", target = "<CMD>BufferPick<CR>" },
    -- Pin/Unpin
    { name = "<M-P>", target = "<CMD>BufferPin<CR>" },
    -- Close buffer
    { name = "<M-c>", target = "<CMD>BufferClose<CR>" },
    -- Concatenation.  Note that this must be at the end.
    -- REF: <https://stackoverflow.com/questions/1410862/concatenation-of-tables-in-lua#comments-54352037>
    table.unpack(mappings.n or {}),
  }

  -- REF: <https://github.com/romgrk/barbar.nvim/#user-content-integration-with-filetree-plugins>
  require("nvim-tree.events").subscribe("TreeOpen", function()
    require("bufferline.api").set_offset(require("nvim-tree.view").View.width + 1)
  end)
  require("nvim-tree.events").subscribe("Resize", function()
    require("bufferline.api").set_offset(require("nvim-tree.view").View.width + 1)
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
  mappings.n = {
    { name = "<C-p>", target = previewer.find_files },
    -- Search for a string in cwd and get results as you type
    { name = "<M-g>", target = previewer.live_grep, options = { noremap = true } },
    -- Searches for the string under cursor in cwd
    { name = "z*", target = previewer.grep_string, options = { noremap = true } },
    { name = "z#", target = previewer.grep_string, options = { noremap = true } },
    { name = "<leader>b", target = previewer.buffers, options = { noremap = true } },
    { name = "<leader>fh", target = previewer.help_tags, options = { noremap = true } },
    { name = "<leader>v", target = previewer.treesitter, options = { noremap = true } },
    -- Concatenation with prev mappings
    table.unpack(mappings.n or {}),
  }
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

  --- nvim-colorizer.lua
  require("colorizer").setup()

  --- copilot.lua, copilot-cmp
  require("copilot").setup({  -- It is recommended to disable copilot.lua's suggestion and panel
                              -- modules, as they can interfere with completions properly appearing
                              -- in copilot-cmp.
                              -- REF: <https://github.com/zbirenbaum/copilot-cmp>
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
  require("copilot_cmp").setup()

  --- cmp
  local cmp = require("cmp")
  local has_words_before = function()  -- REF: <https://github.com/zbirenbaum/copilot-cmp/blob/99467081478aabe4f1183a19a8ba585e511adc20/README.md#user-content-tab-completion-configuration-highly-recommended>
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
  end
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
      ["<Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
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
      { name = "copilot" },
    }),
    formatting = {
      format = require("lspkind").cmp_format({
        mode = "symbol",
        preset = "codicons",
        symbol_map = {
          Copilot = " ",
        };
      }),
    },
  })
  cmp.setup.cmdline(":", { sources = { { name = "cmdline" } } })
  cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
  cmp.setup.cmdline("?", { sources = { { name = "buffer" } } })

  --- navic
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
    lualine_b = {  -- ref: `:h nvim-navic`
      "navic",
      color_correction = nil,
      navic_opts = nil,
    },
    lualine_z = {
      { "filename", cond = function () return vim.bo.buftype ~= "nofile" end }
    },
  }
  require("lualine").setup({
    winbar = winbar,
    inactive_winbar = winbar,
  })

  --- lsp
  local enabled_lsps = {
    "bashls",
    "clangd",
    "cssls",
    "elmls",
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "nil_ls",
    "pyright",
    "rust_analyzer",
    "lua_ls",
    "tailwindcss",
    "taplo",
    "texlab",
    "typst_lsp",
    "yamlls",
  }
  local settings = {
    clangd = {  -- REF: <https://www.reddit.com/r/neovim/comments/12qbcua/comment/jgpqxsp>
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      },
    },
    elm = {
      codeLens = {
        enable = true,
      },
    },
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
    typst_lsp = {
      -- typst-lsp does not support configuring fonts dir, so disable the auto-compilation here and
      -- manually run `typst --font-path=path/to/fonts watch main.typ --open`.
      -- REF:
      --  * <https://github.com/nvarner/typst-lsp/issues/98>
      --  * <https://github.com/nvarner/typst-lsp/issues/120>
      -- NOTE: The settings need to be inside the `settings` object.
      -- REF: <https://github.com/nvarner/typst-lsp/blob/011b579b6e9eaee74353e700996a57f6c3782445/src/server/lsp.rs#L332>
      settings = {
        exportPdf = "never",
      },
    },
  }
  local opts = { buffer = true, noremap = true, silent = true }
  -- REF: :h vim.lsp.buf.hover
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded"
    }
  )
  local on_attach = function(client, bufnr)
    vim.keymap.set("n", "gD", previewer.lsp_type_definitions, opts)
    vim.keymap.set("n", "gd", previewer.lsp_definitions, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gy", previewer.lsp_implementations, opts)
    vim.keymap.set("n", "g;", previewer.lsp_document_symbols, opts)
    vim.keymap.set("n", "g:", previewer.lsp_workspace_symbols, opts)
    vim.keymap.set("n", "<C-n>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    vim.keymap.set("n", "\\D", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>qf", previewer.quickfix, opts)
    vim.keymap.set("n", "gr", previewer.lsp_references, opts)
    vim.keymap.set("n", "<leader>a", previewer.diagnostics, opts)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end
  -- cmp-nvim-lsp provides a more sensible value of default capabilities.
  ---- REF: <https://github.com/hrsh7th/cmp-nvim-lsp>
  ---- Inspect the default capabilities with `:lua print(vim.inspect(require("cmp_nvim_lsp").default_capabilities()))`
  local caps = require("cmp_nvim_lsp").default_capabilities()
  for _, lspname in pairs(enabled_lsps) do
    local lsp_settings = settings[lspname] or {}
    lsp_settings._name = lspname
    lsp_settings.capabilities = lsp_settings.capabilities or caps
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
            -- done before writing buffer and at the moment $FILENAME
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
    -- The file is initially generated via :NvimTreeGenerateOnAttach.
    -- REF: <https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach#user-content-migrating>
    on_attach = dofile("${../raw/neovim/nvim-tree-on_attach.lua}").on_attach,
    update_focused_file = { enable = true },
    diagnostics = { enable = true },
    hijack_cursor = true,  -- keep the cursor on first character
    actions = {
      open_file = {
        quit_on_open = false,
      },
    },
  })
  mappings.n = {
    { name = "<leader>d", target = require("nvim-tree.api").tree.open },
    table.unpack(mappings.n or {}),
  }
  ---- Open on startup
  local function open_nvim_tree()
    local ignore_fts = {
      "gitcommit",
      "gitrebase",
    }
    local filetype = vim.bo.ft
    -- REF: <https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup>
    if vim.tbl_contains(ignore_fts, filetype) then
      return
    end
    -- do not open nvim-tree if current buffer width do not have enough space
    if vim.o.colorcolumn + require("nvim-tree.view").View.width + 2 + 5 >= vim.o.columns then
      return
    end
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
  end
  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
  ---- REF: https://github.com/kyazdani42/nvim-tree.lua#tips--reminders
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
      local tree_wins = {}
      local floating_wins = {}
      local wins = vim.api.nvim_list_wins()
      for _, w in ipairs(wins) do
        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
        if bufname:match("NvimTree_") ~= nil then
          table.insert(tree_wins, w)
        end
        if vim.api.nvim_win_get_config(w).relative ~= "" then
          table.insert(floating_wins, w)
        end
      end
      if 1 == #wins - #floating_wins - #tree_wins then
        -- Should quit, so we close all invalid windows.
        for _, w in ipairs(tree_wins) do
          vim.api.nvim_win_close(w, true)
        end
      end
    end
  })

  --- gitsigns
  require("gitsigns").setup({
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "┃" },
    },
    current_line_blame = true,
  })
  local opts = { noremap = true, silent = true }
  mappings.n = {
    { name = [[\h]], target = "<CMD>Gitsigns preview_hunk<CR>" },
    { name = "[h", target = "<CMD>Gitsigns prev_hunk<CR>" },
    { name = "]h", target = "<CMD>Gitsigns next_hunk<CR>" },
    { name = "<leader>hs", target = "<CMD>Gitsigns stage_hunk<CR>" },
    { name = "<leader>hd", target = "<CMD>Gitsigns undo_stage_hunk<CR>" },
    { name = "<leader>hu", target = "<CMD>Gitsigns reset_hunk<CR>" },
    { name = "<leader>gb", target = "<CMD>Gitsigns toggle_current_line_blame<CR>" },
    table.unpack(mappings.n or {}),
  }

  --- treesitter, ts-rainbow
  rainbow = require "rainbow-delimiters"
  vim.g.rainbow_delimiters = {
    strategy = {
      -- Use global strategy by default
      [""] = rainbow.strategy['global'],
      -- Use local for HTML
      html = rainbow.strategy['local'],
      -- Pick the strategy for LaTeX dynamically based on the buffer size
      latex = function()
        if vim.fn.line('$') > 1000 then
            return rainbow.strategy['global']
        end
        return rainbow.strategy['local']
      end,
    },
    query = {
      [""] = "rainbow-delimiters",
      html = "rainbow-tags",
      xml = "rainbow-tags",
      latex = "rainbow-blocks",
    },
    highlight = {
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      -- "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
      "RainbowDelimiterRed",  -- red color is very conspicuous and not very aesthetic, use it for very deeply nested blocks
    },
  }
  vim.cmd([[
    highlight RainbowDelimiterRed guifg=${themeColor "red"} ctermfg=red
    highlight RainbowDelimiterYellow guifg=${themeColor "yellow"} ctermfg=yellow
    highlight RainbowDelimiterBlue guifg=${themeColor "blue"} ctermfg=blue
    highlight RainbowDelimiterOrange guifg=${themeColor "orange"} ctermfg=white
    highlight RainbowDelimiterGreen guifg=${themeColor "green"} ctermfg=green
    highlight RainbowDelimiterCyan guifg=${themeColor "cyan"} ctermfg=cyan
    highlight RainbowDelimiterViolet guifg=${themeColor "purple"} ctermfg=magenta
  ]])
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
  })
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  vim.o.foldenable = false ---- After changing this, run :PackerCompile to take effect

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

  -- fcitx5-ui
  local lualine_cfg = require("lualine").get_config()
  local function get_im()
    local fcitx5_ui_mod = prequire("fcitx5-ui")
    local mapping = {
      [""] = " ",
      ["keyboard-us"] = " ",
      ["pinyin"] = "中",
    }
    if fcitx5_ui_mod then
      local ok, im = pcall(fcitx5_ui_mod.getCurrentIM)
      if ok then
        return mapping[im]
      else
        return " "
      end
    else
      return " "
    end
  end
  if not GET_IM_INSERTED then
    table.insert(lualine_cfg.sections.lualine_y, get_im)
    GET_IM_INSERTED = true
  end
  require("lualine").setup(lualine_cfg)
  local toggle_fcitx5_mapping = {
    name = [[<C-\>]],
    target = function()
      local fcitx5_ui_mod = prequire("fcitx5-ui")
      if not fcitx5_ui_mod then
        local msg = "Could not toggle IM, is fcitx5 running?"
        vim.api.nvim_echo({{msg, "WarningMsg"}}, true, {})
      else
        local ok, _ = pcall(fcitx5_ui_mod.toggle)
        if not ok then
          vim.api.nvim_echo({{"Failed to toggle IM, did fcitx5 die?", "ErrorMsg"}}, true, {})
        end
      end
    end,
  }
  mappings.ni = { toggle_fcitx5_mapping, table.unpack(mappings.ni or {}) }

  -- comment.nvim
  require("Comment").setup()

  -- keymaps
  local function set_keymaps()
    for mode, map in pairs(mappings) do
      mode_list = {}
      for i = 1, #mode do
        table.insert(mode_list, mode:sub(i, i))
      end
      for _, entry in ipairs(map) do
        local options = mapping_options
        if entry.options ~= nil then
          for k, v in pairs(entry.options) do
            options[k] = v
          end
        end
        vim.keymap.set(mode_list, entry.name, entry.target, options)
      end
    end
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, { callback = set_keymaps })
''
