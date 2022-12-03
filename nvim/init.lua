-- Programs needed: unzip, ripgrep, fd

-- Notes: (for particular LSP services)
-- `prettierd` requires that nodejs and npm be installed locally
-- `jdtls` (Java LSP) only works with projects, e.g., Gradle or Maven

-------------
-- PLUGINS --
-------------

-- Speed up plugins' load time
-- (must install impatient.nvim first)
require("impatient")

-- Auto-install packer
local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  Packer_bootstrap = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    packer_install_path,
  })
end

local packer = require("packer")

-- Tell packer to use popups
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- The great plugins list
packer.startup(function()
  -- Self-manage
  use("wbthomason/packer.nvim")

  -- Library for other plugins
  use("nvim-lua/plenary.nvim")

  -- Speed up plugins' load time
  -- (Refer to the first function in this config)
  use("lewis6991/impatient.nvim")

  -- Test startup time
  use("dstein64/vim-startuptime")

  -- EDIT --

  -- Swiss army knife
  use({
    "echasnovski/mini.nvim",
    config = function()
      -- More targets
      require("mini.ai").setup()

      -- Surround
      require("mini.surround").setup()

      -- Pairs
      require("mini.pairs").setup()

      -- Comments
      require("mini.comment").setup()
    end,
  })

  -- Indent
  use({
    "NMAC427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  })

  -- Move code
  use({
    "booperlv/nvim-gomove",
    config = function()
      require("gomove").setup()
    end,
  })

  -- VIEW --

  -- Indent guide
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        use_treesitter = true,
      })
    end,
  })

  -- Colorscheme
  -- use({
  --   "eddyekofo94/gruvbox-flat.nvim",
  --   config = function()
  --     vim.g.gruvbox_flat_style = "hard"
  --     vim.cmd.colorscheme("gruvbox-flat")
  --   end,
  -- })
  use({
    "luisiacc/gruvbox-baby",
    config = function()
      vim.g.gruvbox_baby_background_color = "dark"
      vim.g.gruvbox_baby_highlights = {
        Search = { fg = "#1d2021", bg = "#ebdbb2", style = "NONE" },
        IncSearch = { fg = "#1d2021", bg = "#ebdbb2", style = "NONE" },
      }
      vim.cmd.colorscheme("gruvbox-baby")
    end,
  })

  -- Syntax highlight
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      -- From wiki: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          -- false will disable the whole extension
          enable = true,

          -- list of language that will be disabled
          disable = {},
        },
      })
    end,
  })

  -- Todo highlight
  use({
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({
        signs = false,
        highlight = {
          keyword = "bg",
        },
      })
    end,
  })

  -- Statusline and tabline
  use("nvim-lualine/lualine.nvim")

  -- Icons
  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({})
    end,
  })

  -- COPILOTS --

  -- Package manager
  use({
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  })

  -- LSP
  use({
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  })
  use("neovim/nvim-lspconfig")
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.formatting.prettierd,
          require("null-ls").builtins.formatting.shellharden,
          require("null-ls").builtins.diagnostics.fish,
        },
      })
    end,
  })

  -- LSP server status
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        text = {
          spinner = "dots",
          done = "✔",
          commenced = "Started",
          completed = "Completed",
        },
      })
    end,
  })

  -- Auto-complete
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp-signature-help")

  -- Snippets
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- Rust
  use({
    "saecki/crates.nvim",
    tag = "v0.2.1",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  })

  -- COMMAND TOOLS --

  -- Command aid and remap
  use("folke/which-key.nvim")

  -- Git
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "▁" },
          topdelete = { text = "▔" },
          changedelete = { text = "~" },
        },
      })
    end,
  })

  -- Search
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-ui-select.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope-file-browser.nvim" })

  -- Trees
  use({
    "mbbill/undotree",
    config = function()
      -- Open on the right
      vim.g.undotree_WindowLayout = 3
    end,
  })

  -- Auto-load all the above
  -- if packer is installed for the first time
  if Packer_bootstrap then
    require("packer").sync()
  end
end)

--------------
-- SETTINGS --
--------------

-- General settings
vim.opt.title = true
vim.opt.hidden = true
vim.opt.linebreak = true
vim.opt.completeopt = "menuone,noselect"

-- Basic theme settings
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.g.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
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

-- Ignore case (unless specified) in regex
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- No magic in regex
vim.opt.magic = false

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

-- Fix lua API keyboard interrupt issue
wk.register({
  ["<C-c>"] = { "<C-[>", "escape" },
}, { mode = "i" })

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

-- The great <leader> remap
wk.register({
  ["<leader>"] = {
    name = "leader",
    -- Basics
    w = { "<cmd>wa!<cr>", "save" },
    q = { "<cmd>qa!<cr>", "quit" },
    -- Telescopes (All left hand shorthands)
    a = { require("telescope.builtin").lsp_document_symbols, "symbols" },
    s = { require("telescope.builtin").live_grep, "search" },
    d = { require("telescope.builtin").diagnostics, "diagnostics" },
    f = { require("telescope.builtin").find_files, "files" },
    e = { require("telescope").extensions.file_browser.file_browser, "file browser" },
    r = { require("telescope.builtin").resume, "resume search" },
    t = { "<cmd>TodoTelescope<cr>", "todo" },
    -- Undo tree
    u = { "<cmd>UndotreeToggle<cr>", "undotree" },
    -- Interface
    n = { "<cmd>nohlsearch<cr>", "nohl" },
    p = {
      name = "packer",
      p = { "<cmd>PackerSync<cr>", "sync" },
      s = { "<cmd>PackerStatus<cr>", "status" },
    },
    g = {
      name = "git",
      -- Statuses
      b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "blame" },
      d = { "<cmd>Gvdiffsplit<cr>", "diff with head" },
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
      v = { "<cmd>Gitsigns preview_hunk<cr>", "view" },
      -- Move
      n = { "<cmd>Gitsigns next_hunk<cr>", "next" },
      p = { "<cmd>Gitsigns prev_hunk<cr>", "previous" },
      -- Stage
      s = { "<cmd>Gitsigns stage_hunk<cr>", "stage" },
      u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "undo stage" },
      r = { "<cmd>Gitsigns reset_hunk<cr>", "reset" },
    },
    i = {
      name = "interface",
      n = { "<cmd>set number!<cr>", "number" },
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

local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--fixed-strings", -- no magic
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
    file_browser = {},
  },
})

-- Load telescope extensions
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("file_browser")

---------
-- LSP --
---------

-- Don't use virtual text (the text at the end of line)
-- It is too disturbing to workflow
vim.diagnostic.config({
  virtual_text = false,
})

-- Use nerd font for gutter signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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

  if server == "sumneko_lua" then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "use" },
        },
        runtime = {
          version = "LuaJIT",
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
          },
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

require("luasnip.loaders.from_vscode").lazy_load()

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

    -- Disable in strings
    if context.in_treesitter_capture("string") or context.in_syntax_group("String") then
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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.confirm()
        end
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
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
  options = { section_separators = "", component_separators = "" },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "b:gitsigns_head", icon = "" },
      { "diff", source = gitsigns_diff_source, symbols = { added = " ", modified = " ", removed = " " } },
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
