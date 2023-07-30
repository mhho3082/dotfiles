-- Programs needed: unzip, ripgrep, fd

-- Notes: (for particular LSP services)
-- `prettierd` requires that nodejs and npm be installed locally
-- `jdtls` (Java LSP) only works with projects, e.g., Gradle or Maven

-------------
-- PLUGINS --
-------------

-- Speed up plugins' load time
vim.loader.enable()

-- Auto-install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

-- The great plugins list
lazy.setup({
  -- EDIT --

  -- Swiss army knife
  {
    "echasnovski/mini.nvim",
    config = function()
      -- More targets
      require("mini.ai").setup()

      -- Surround
      require("mini.surround").setup()

      -- Comments
      require("mini.comment").setup()

      -- Align
      require("mini.align").setup()

      -- Move code
      require("mini.move").setup({
        mappings = {
          -- Disable using <M-_> for moving in normal mode
          -- To prevent colliding with inter-window movements
          line_left = "",
          line_right = "",
          line_down = "",
          line_up = "",
        },
      })

      -- Multi-line f/t
      require("mini.jump").setup({
        -- Delay values (in ms) for different functionalities. Set any of them to
        -- a very big number (like 10^7) to virtually disable.
        delay = {
          -- Delay between jump and highlighting all possible jumps
          highlight = 10000000,

          -- Delay between jump and automatic stop if idle (no jump is done)
          idle_stop = 0,
        },
      })
    end,
  },

  -- Indent
  "tpope/vim-sleuth",

  -- Splitjoin
  {
    "Wansmer/treesj",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("treesj").setup({})
    end,
  },

  -- Pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- File browser
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
        },
        -- Deleted files will be removed with the `trash-put` command
        delete_to_trash = true,
      })
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    config = function()
      -- Open on the right
      vim.g.undotree_WindowLayout = 3
    end,
  },

  -- Move around better
  {
    "chrisgrieser/nvim-spider",
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
  },

  -- VIEW --

  -- Indent guide
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        use_treesitter = true,
      })
    end,
  },

  -- Colorscheme
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.background = "dark"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- Syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "comment", "markdown", "markdown_inline" },
        highlight = {
          -- false will disable the whole extension
          enable = true,
          -- list of language that will be disabled
          disable = {},
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            node_incremental = "<cr>",
            scope_incremental = "<s-cr>",
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Statusline and tabline
  "nvim-lualine/lualine.nvim",

  -- Icons
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({})
    end,
  },

  -- COPILOTS --

  -- Package manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  "neovim/nvim-lspconfig",
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.diagnostics.zsh,
          -- require("null-ls").builtins.diagnostics.eslint,
          require("null-ls").builtins.formatting.clang_format,
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.formatting.prettierd.with({
            extra_filetypes = { "svelte" },
          }),
          require("null-ls").builtins.formatting.beautysh,
        },
      })
    end,
  },

  -- LSP server status
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
          done = "✓",
          commenced = "Started",
          completed = "Completed",
        },
      })
    end,
  },

  -- Auto-complete
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp-signature-help",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- COMMAND TOOLS --

  -- Command aid and remap
  "folke/which-key.nvim",

  -- Git
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({})
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup()
    end,
  },

  -- Search
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-ui-select.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
  },
  "nvim-telescope/telescope-ui-select.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = false },
})

--------------
-- SETTINGS --
--------------

-- General settings
vim.opt.title = true
vim.opt.hidden = true
vim.opt.linebreak = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.mousemodel = "extend"

-- Basic theme settings
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.g.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"

-- Don't disturb me (by default)
vim.opt.number = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.cursorline = false

-- Split below (s) and right (v)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Default indent
-- (sleuth overrides this if indent format found)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- No backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Persistence for undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir/"

-- Allow to read project-local configs
vim.opt.exrc = true

-- Remove 'c no curly braces' errors
vim.g.c_no_curly_error = 1

-- Set spelling locale
vim.opt.spelllang = "en_gb"

-- Markdown code block rendering
vim.g.markdown_minlines = 100
vim.g.markdown_fenced_languages = {
  "c",
  "c++=cpp",
  "make",
  "cmake",
  "python",
  "java",
  "rust",
  "erb=eruby",
  "ruby",
  "javascript",
  "js=javascript",
  "json=javascript",
  "typescript",
  "bash=sh",
  "fish=sh",
  "zsh",
  "conf",
  "html",
  "css",
  "toml",
  "yaml",
}

-- Assuming number is on, toggle to relativenumber in normal mode
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    if vim.wo.number == true then
      vim.wo.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    if vim.wo.number == true then
      vim.wo.relativenumber = true
    end
  end,
})

------------
-- REMAPS --
------------

local wk = require("which-key")

-- Setup which-key
wk.setup({
  plugins = {
    spelling = {
      enabled = true,
    },
  },
  layout = {
    align = "center",
  },
})

-- Leader key
vim.g.mapleader = " "

-- Setups that which-key advices
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 0

-- Move cursor by display lines by default
vim.keymap.set({ "n", "v", "o", "x" }, "j", "gj", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "o", "x" }, "k", "gk", { noremap = true, silent = true })

-- Fix lua API keyboard interrupt issue
wk.register({
  ["<C-c>"] = { "<C-[>", "escape" },
}, { mode = "i" })

-- Add easy copy/paste to system clipboard
wk.register({
  ["gy"] = { '"+y', "Copy to clipboard" },
  ["gY"] = { '"+Y', "Copy to clipboard" },
  ["gp"] = { '"+p', "Paste from clipboard" },
  ["gP"] = { '"+P', "Paste from clipboard" },
}, { mode = "n" })
wk.register({
  ["gy"] = { '"+y', "Copy to clipboard" },
  ["gY"] = { '"+Y', "Copy to clipboard" },
  ["gp"] = { '"+p', "Paste from clipboard" },
  ["gP"] = { '"+P', "Paste from clipboard" },
}, { mode = "v" })

-- Operate on windows with <M-_> in normal mode
-- (<M-_> is used to move code in visual mode)
wk.register({
  ["<M-h>"] = { "<C-w>h", "Move to left window" },
  ["<M-j>"] = { "<C-w>j", "Move to lower window" },
  ["<M-k>"] = { "<C-w>k", "Move to upper window" },
  ["<M-l>"] = { "<C-w>l", "Move to right window" },
  ["<M-v>"] = { "<C-w>v", "Split vertically" },
  ["<M-s>"] = { "<C-w>s", "Split" },
  ["<M-c>"] = { "<C-w>c", "Close window" },
}, { mode = "n" })

-- LSP mappings
wk.register({
  ["J"] = {
    '<cmd>lua vim.diagnostic.open_float(0, { scope = "cursor" })<cr>',
    "diagnostics",
  },
  ["K"] = { vim.lsp.buf.hover, "hover" },
  ["gr"] = { vim.lsp.buf.rename, "rename" },
  ["gd"] = { require("telescope.builtin").lsp_definitions, "goto definition" },
  ["gD"] = { require("telescope.builtin").lsp_implementations, "goto implementation" },
  ["<leader>j"] = { vim.lsp.buf.code_action, "code action" },
  ["<leader>k"] = { vim.lsp.buf.format, "format" },
  ["<C-j>"] = { vim.diagnostic.goto_next, "next diagnostic" },
  ["<C-k>"] = { vim.diagnostic.goto_prev, "prev diagnostic" },
}, { mode = "n" })
wk.register({
  ["<leader>j"] = { vim.lsp.buf.code_action, "code action" },
  ["<leader>k"] = { vim.lsp.buf.format, "format" },
}, { mode = "v" })

-- Splitjoin mappings
wk.register({
  ["gs"] = { "<cmd>TSJSplit<cr>", "split node" },
  ["gj"] = { "<cmd>TSJJoin<cr>", "join node" },
}, { mode = "n" })

-- Click '-' in any buffer to open its parent directory in oil.nvim
wk.register({
  ["-"] = { require("oil").open, "Open parent directory" },
}, { mode = "n" })

-- Ideas from https://github.com/folke/todo-comments.nvim/blob/main/lua/telescope/_extensions/todo-comments.lua
-- But is way lighter
function TodoTelescope()
  require("telescope.builtin").grep_string({
    prompt_title = "Find Todo",
    search = "(TODO|NOTE|INFO|TEST|TEMP|FIXME|XXX|BUG|DEBUG|HACK|UNDONE)(\\(.*\\))?:",
    use_regex = true,
    additional_args = { "--trim" },
  })
end

-- The great <leader> remap
wk.register({
  ["<leader>"] = {
    name = "leader",
    -- Basics
    w = { "<cmd>wa!<cr>", "save" },
    q = { "<cmd>qa!<cr>", "quit" },
    c = { '<cmd>let @+ = expand("%:p")<cr><cmd>echo expand("%:p")<cr>', "copy filename" },
    -- Telescopes
    f = { require("telescope.builtin").find_files, "files" },
    a = { require("telescope.builtin").lsp_document_symbols, "symbols" },
    s = { require("telescope.builtin").live_grep, "search" },
    d = { require("telescope.builtin").diagnostics, "diagnostics" },
    x = { TodoTelescope, "todo" }, -- "Marked"
    r = { require("telescope.builtin").resume, "resume search" },
    -- File browser (oil)
    o = { require("oil").open_float, "file browser" },
    -- Undo tree
    u = { "<cmd>UndotreeToggle<cr>", "undotree" },
    -- Interface
    n = { "<cmd>nohlsearch<cr>", "nohl" },
    t = {
      name = "tabs",
      h = { "<cmd>tabprev<cr>", "previous" },
      l = { "<cmd>tabnext<cr>", "next" },
      H = { "<cmd>tabfirst<cr>", "first" },
      L = { "<cmd>tablast<cr>", "last" },
      n = { "<cmd>tabnew<cr>", "new" },
      c = { "<cmd>tabclose<cr>", "close" },
      o = { "<cmd>tabonly<cr>", "close all others" },
    },
    p = {
      name = "packer",
      p = { "<cmd>PackerSync<cr>", "sync" },
      s = { "<cmd>PackerStatus<cr>", "status" },
    },
    g = {
      name = "git",
      -- Statuses
      b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "blame" },
      d = { "<cmd>DiffviewOpen<cr>", "diff with head" }, -- Or Gvdiffsplit
      -- Fetch
      f = { "<cmd>G fetch<cr>", "fetch" },
      m = { "<cmd>G merge<cr>", "merge" },
      -- Commit
      a = { "<cmd>G add %<cr>", "add file" },
      c = { "<cmd>G commit<cr>", "commit" },
      p = { "<cmd>G push<cr>", "push" },
    },
    h = {
      name = "git hunks",
      -- View
      d = { "<cmd>Gitsigns preview_hunk<cr>", "diff" },
      -- Select
      v = { "<cmd>Gitsigns select_hunk<cr>", "visual" },
      -- Move
      n = { "<cmd>Gitsigns next_hunk<cr>", "next" },
      p = { "<cmd>Gitsigns prev_hunk<cr>", "previous" },
      -- Stage (or reset)
      s = { "<cmd>Gitsigns stage_hunk<cr>", "stage" },
      u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "undo stage" },
      r = { "<cmd>Gitsigns reset_hunk<cr>", "reset" },
    },
    i = {
      name = "interface",
      n = { "<cmd>set number! relativenumber!<cr>", "number" },
      s = { "<cmd>set spell!<cr>", "spell" },
      w = { "<cmd>set wrap!<cr>", "wrap" },
      i = { "<cmd>IndentBlanklineToggle<cr>", "indentline" },
      b = { '<cmd>let &background = ( &background == "dark"? "light" : "dark" )<cr>', "background" },
    },
  },
})

---------------
-- TELESCOPE --
---------------

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- find hidden files
      "--glob",
      "!.git/*",
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type",
        "f",
        "-H",
        "--strip-cwd-prefix",
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

-- Load telescope extensions
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

---------
-- LSP --
---------

-- Don't use virtual text (the text at the end of line)
-- It is too disturbing to workflow
vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
})

-- Use nerd font for gutter signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup all LSP servers installed by Mason
for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
  local opts = {}
  opts.capabilities = capabilities

  if server == "rust_analyzer" then
    opts.settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
      },
    }
  end

  if server == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        runtime = {
          version = "LuaJIT",
        },
        format = {
          enable = false,
        },
      },
    }
  end

  if server == "ltex" then
    opts.settings = {
      ltex = {
        language = "en-GB",
        dictionary = {
          ["en-GB"] = {
            "neovim",
            "fzf",
            "ripgrep",
            "fd",
            "dotfiles",
            "zsh",
            "Hin",
            "ArchWiki",
            "newpage",
            "gruvbox",
          },
        },
        checkFrequency = "save",
      },
    }
  end

  if server == "jdtls" then
    opts.settings = {
      java = {
        format = {
          enabled = false,
        },
      },
    }
  end

  require("lspconfig")[server].setup(opts)
end

---------
-- CMP --
---------

local cmp = require("cmp")

require("luasnip.loaders.from_vscode").lazy_load({
  exclude = { "html" },
})

cmp.setup({
  enabled = function()
    -- Enable in command mode
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    end

    -- Disable in Telescope window
    local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
    if in_prompt then
      return false
    end

    local context = require("cmp.config.context")

    -- Disable in comments
    if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
      return false
    end

    return true
  end,
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "nvim_lua" },
    { name = "nvim_lsp_signature_help" },
    { name = "crates" },
  }),
})

-- Command line autocomplete
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-------------
-- LUALINE --
-------------

-- gitsigns integration copied from:
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-branch

-- Gitsigns diff
local function gitsigns_diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- Boot up lualine
require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "b:gitsigns_head", icon = "" },
      {
        "diff",
        source = gitsigns_diff_source,
        symbols = { added = " ", modified = " ", removed = " " },
      },
    },
    lualine_c = {
      { "filename", path = 1 },
      { "diagnostics", sources = { "nvim_lsp" } },
    },
    lualine_x = { "filetype", "fileformat", "encoding" },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1, symbols = { modified = "" } } },
    lualine_x = { { "filetype", colored = false } },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "nvim-tree", "fugitive" },
})
