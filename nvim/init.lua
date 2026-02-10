-- Programs needed: `unzip`, `ripgrep`, `fd`

-- Programs advised:
-- `tree-sitter` (and `tree-sitter-cli`) for install-from-grammer syntax files, esp. LaTeX
-- `fswatch` on Linux to improve LSP file watching performance (see https://www.reddit.com/r/neovim/comments/1b4bk5h)

-- Notes: (for particular LSP services)
-- `prettierd` requires that `nodejs` and `npm` be installed globally
-- `jdtls` (Java LSP) only works with projects

--------------
-- SETTINGS --
--------------

-- General settings
vim.opt.title = true
vim.opt.hidden = true
vim.opt.linebreak = true
vim.opt.completeopt = "menuone,noselect"
vim.opt.mousemodel = "extend"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic theme settings
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
vim.opt.conceallevel = 2 -- For writing prose

-- Don't disturb me (by default)
vim.opt.number = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false

-- Set cursor types
-- (modified from Neovim default: https://neovim.io/doc/user/options.html#'guicursor')
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"

-- If number is on,
-- highlight current line number (but not the whole line)
-- https://stackoverflow.com/a/13275419
vim.opt.cursorline = true
local cursorline_hl = nil
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    cursorline_hl = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
    vim.api.nvim_set_hl(0, "CursorLine", {})
    local v = vim.api.nvim_get_hl(0, { name = "CursorLineNR", link = false })
    v.bold = true
    vim.api.nvim_set_hl(0, "CursorLineNR", v)
  end,
})

-- Restore `cursorline` highlight when toggled on
local cursorline_enabled = false
local function toggle_cursorline()
  cursorline_enabled = not cursorline_enabled
  if cursorline_enabled then
    vim.api.nvim_set_hl(0, "CursorLine", cursorline_hl)
  else
    vim.api.nvim_set_hl(0, "CursorLine", {})
  end
end

-- Use dark background by default
vim.opt.background = "dark"
local function toggle_background()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end

-- Split below (s) and right (v)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Default indent: 4 spaces
-- (sleuth overrides this if indent format found)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- 2 spaces default indents
-- https://stackoverflow.com/q/158968
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "javascript,typescript,json,jsonc,svelte,vue,html,css,scss,sass,lua,markdown,sh,zsh,fish",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  end,
})
-- Tab default indents
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "make,just",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = false
  end,
})

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

-- Add alias for files
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/2131
-- https://github.com/neovim/neovim/pull/16600
vim.filetype.add({
  extension = {
    -- For Markdown inline block
    matplotlib = "python",
  },
  pattern = {
    -- https://neovim.discourse.group/t/how-to-add-custom-filetype-detection-to-various-env-files/4272
    [".env.*"] = "config",
  },
})

-------------
-- PLUGINS --
-------------

-- Speed up plugins' load time
vim.loader.enable()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

-- A quick function to set keymaps;
-- see https://neovim.io/doc/user/lua.html#vim.keymap.set()
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param options? table
local function keymap(mode, lhs, rhs, options)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { noremap = true, silent = true }, options or {}))
end

-- The great plugins list
lazy.setup({
  spec = {
    -- EDIT --

    -- Swiss army knife ("mini.nvim")
    -- More targets
    { "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },
    -- Surround
    { "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },
    -- Comments
    {
      "nvim-mini/mini.comment",
      event = "VeryLazy",
      opts = {
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      },
    },
    -- Multiline `f`/`t`
    {
      "nvim-mini/mini.jump",
      event = "VeryLazy",
      opts = {
        -- Delay values (in ms) for different functionalities. Set any of them to
        -- a very big number (like 10^7) to virtually disable.
        delay = {
          -- Delay between jump and highlighting all possible jumps
          highlight = 100000000,

          -- Delay between jump and automatic stop if idle (no jump is done)
          idle_stop = 0,
        },
      },
    },
    -- Trailspace
    { "nvim-mini/mini.trailspace", event = "VeryLazy", opts = {} },

    -- Move around better
    { "chrisgrieser/nvim-spider", event = "VeryLazy" },

    -- Readline-like insertion
    { "tpope/vim-rsi", event = "VeryLazy" },

    -- Indent
    { "tpope/vim-sleuth", event = "VeryLazy" },

    -- Splitjoin
    {
      "Wansmer/treesj",
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = { use_default_keymaps = false },
    },

    -- Pairs
    { "windwp/nvim-autopairs", event = "VeryLazy", opts = {} },
    { "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },

    -- File browser
    {
      "stevearc/oil.nvim",
      lazy = false,
      opts = {
        view_options = {
          show_hidden = true,
          -- Don't display `../`
          is_always_hidden = function(name, _)
            return name == ".."
          end,
        },
        delete_to_trash = true,
        watch_for_changes = true,
      },
    },

    -- Undo tree
    {
      "mbbill/undotree",
      event = "VeryLazy",
      config = function()
        -- Open on the right
        vim.g.undotree_WindowLayout = 3
      end,
    },

    -- VIEW --

    -- Indent guide
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      event = "VeryLazy",
      opts = {
        indent = { char = "│" },
        scope = { enabled = false },
      },
      dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Colorscheme
    {
      "sainnhe/gruvbox-material",
      lazy = false,
      priority = 1000,
      config = function()
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_better_performance = true
        vim.cmd.colorscheme("gruvbox-material")
      end,
    },

    -- Syntax highlight
    {
      "nvim-treesitter/nvim-treesitter",
      build = function()
        require("nvim-treesitter.install").update({})()
      end,
      event = "VeryLazy",
      branch = "master",
      dependencies = {
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          opts = { enable_autocmd = false },
          config = function()
            vim.g.skip_ts_context_commentstring_module = true
          end,
        },
      },
      opts = {
        --stylua: ignore start
        ensure_installed = {
          -- Programming
          "c", "cpp", "make", "python", "java", "rust",
          "javascript", "typescript", "jsdoc", "vue", "svelte",
          -- Scripting
          "html", "css", "scss", "json", "jsonc", "regex", "bash",
          "php", "php_only", "phpdoc", "blade",
          -- Git
          "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
          -- Prose
          "markdown", "markdown_inline", "bibtex", "mermaid",
          -- Config
          "rasi", -- For rofi
          "yaml", "toml", "zathurarc", "xresources",
          -- Vim-specific
          "vim", "vimdoc", "comment", "lua", "luadoc", "diff",
        },
        --stylua: ignore end
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
      },
      config = function(_, opts)
        -- Blade Treesitter install based on https://github.com/EmranMR/tree-sitter-blade/discussions/19
        -- also see `after/` folder for SCM code

        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

        parser_config.blade = {
          install_info = {
            url = "https://github.com/EmranMR/tree-sitter-blade",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "blade",
        }

        vim.filetype.add({
          pattern = {
            [".*%.blade%.php"] = "blade",
          },
        })

        require("nvim-treesitter.configs").setup(opts)
      end,
    },

    -- Statusline and tab-line
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      config = function()
        -- gitsigns integration copied from:
        -- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
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
          extensions = { "fugitive", "fzf", "lazy", "mason", "oil" },
        })
      end,
    },

    -- Icons
    { "nvim-tree/nvim-web-devicons", event = "VeryLazy", opts = {} },

    -- COPILOTS --

    -- Autocomplete
    {
      "saghen/blink.cmp",
      version = "*",
      event = "VeryLazy",
      dependencies = { "fang2hou/blink-copilot" },
      opts = {
        keymap = { preset = "super-tab" },
        sources = {
          default = function(_)
            local ok, node = pcall(vim.treesitter.get_node)
            if ok and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
              return { "copilot", "path", "buffer" }
            else
              return { "copilot", "lsp", "path", "snippets", "buffer" }
            end
          end,
          providers = {
            copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
            buffer = { min_keyword_length = 4 },
          },
        },
        cmdline = {
          keymap = {
            preset = "cmdline",
            ["<Tab>"] = { "select_and_accept", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
          },
          completion = { menu = { auto_show = true } },
        },
        completion = {
          list = { selection = { auto_insert = false } },
          documentation = { auto_show = true, auto_show_delay_ms = 0 },
        },
        signature = { enabled = true },
        fuzzy = { implementation = "prefer_rust" },
      },
      opts_extend = { "sources.default" },
    },

    -- GitHub Copilot
    {
      "zbirenbaum/copilot.lua",
      event = "VeryLazy",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = { markdown = true, yaml = true, help = true },
      },
    },
    -- Chat
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      build = "make tiktoken",
      -- https://copilotc-nvim.github.io/CopilotChat.nvim/#/?id=configuration
      opts = {
        model = "gpt-5.1", -- AI model to use
        temperature = 0.1, -- Lower = focused, higher = creative
        window = {
          layout = "vertical", -- 'vertical', 'horizontal', 'float'
          width = 0.5, -- 50% of screen width
        },
      },
    },

    -- LSP
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        { "mason-org/mason-lspconfig.nvim", opts = {} },
        "saghen/blink.cmp",
      },
      event = "VeryLazy",
      config = function()
        -- Note: The whole LSP config is here
        vim.diagnostic.config({
          -- Don't use virtual text (the text at the end of line)
          -- It is too disturbing to workflow
          virtual_text = false,
          severity_sort = true,
          -- Use nerd font for gutter signs
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚",
              [vim.diagnostic.severity.WARN] = "󰀪",
              [vim.diagnostic.severity.INFO] = "󰋽",
              [vim.diagnostic.severity.HINT] = "󰌶",
            },
          },
        })

        local _, blink = pcall(require, "blink.cmp")
        if blink then
          vim.lsp.config("*", {
            capabilities = blink.get_lsp_capabilities(),
          })
        end

        -- Specific handlers
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              runtime = { version = "LuaJIT" },
              format = { enable = false },
            },
          },
        })
        vim.lsp.config("rust_analyzer", {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              imports = { granularity = { group = "module" }, prefix = "self" },
              cargo = { buildScripts = { enable = true } },
              procMacro = { enable = true },
            },
          },
        })
        vim.lsp.config("harper_ls", {
          settings = {
            ["harper-ls"] = {
              linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
              },
            },
          },
        })
        vim.lsp.config("jdtls", { settings = { java = { format = { enabled = false } } } })
        vim.lsp.config("html", {
          -- https://github.com/LazyVim/LazyVim/discussions/2159
          init_options = {
            provideFormatter = false,
          },
        })
        vim.lsp.config("cssls", {
          -- https://github.com/LazyVim/LazyVim/discussions/2159
          init_options = {
            provideFormatter = false,
          },
        })

        -- Make pyright and basedpyright use the correct pyenv version if provided
        -- https://stackoverflow.com/a/78916731
        if vim.fn.executable("pyenv") == 1 then
          vim.env.PYENV_VERSION = vim.fn.system("pyenv version-name")
        end
      end,
    },

    -- Handling servers without automatic LSP configuration
    {
      "nvimtools/none-ls.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.blade_formatter,
            null_ls.builtins.formatting.shfmt.with({
              -- https://github.com/mvdan/sh/issues/212
              args = { "-i", "2", "-ci", "-filename", "$FILENAME" },
            }),
          },
        })
      end,
    },

    -- LSP server status
    {
      "j-hui/fidget.nvim",
      event = "VeryLazy",
      opts = { progress = { ignore = { "harper_ls" }, display = { render_limit = 5, done_icon = "✓" } } },
    },

    -- COMMAND TOOLS --

    -- Command aid and keymaps
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = { preset = "helix" },
      config = function(_, opts)
        -- Note: Most of the keymap config is here

        local wk = require("which-key")

        if opts then
          wk.setup(opts)
        end

        local _, spider = pcall(require, "spider")
        local _, treesj = pcall(require, "treesj")
        local _, oil = pcall(require, "oil")
        local _, fzf = pcall(require, "fzf-lua")
        local _, grug = pcall(require, "grug-far")

        -- Move cursor by display lines by default
        vim.tbl_map(function(ops)
          keymap({ "n", "v", "o", "x" }, ops, "g" .. ops)
        end, { "j", "k", "0", "^", "$", "<Down>", "<Up>" })

        -- Better `w`, `e`, and `b` motions
        vim.tbl_map(function(ops)
          keymap({ "n", "v", "o", "x" }, ops, function()
            spider.motion(ops)
          end, { desc = "Spider-" .. ops })
        end, { "w", "e", "b", "ge" })

        -- Fix Lua API keyboard interrupt issue
        keymap("i", "<C-c>", "<C-[>", { desc = "Escape" })

        -- Open oil with -
        keymap({ "n" }, "-", oil.open, { desc = "Open oil.nvim" })

        -- Split/join lines
        keymap({ "n" }, "gs", treesj.split, { desc = "Split" })
        keymap({ "n" }, "gj", treesj.join, { desc = "Join" })

        -- Add easy copy/paste to system clipboard
        keymap({ "n", "x" }, "gy", '"+y', { desc = "Copy to clipboard" })
        keymap({ "n", "x" }, "gY", '"+Y', { desc = "Copy to clipboard" })
        keymap({ "n", "x" }, "gp", '"+p', { desc = "Paste to clipboard" })
        keymap({ "n", "x" }, "gP", '"+P', { desc = "Paste to clipboard" })

        -- Operate on windows with <M-_> in normal mode
        vim.tbl_map(function(ops)
          keymap("n", "<M-" .. ops .. ">", "<C-w>" .. ops)
        end, { "h", "j", "k", "l", "v", "s", "c" })
        vim.tbl_map(function(ops)
          keymap("n", "<M-" .. ops .. ">", "<C-w><" .. ops .. ">")
        end, { "Left", "Down", "Up", "Right" })

        -- Allow zz to work in visual mode (for the whole selection)
        local function CenterVisualSelection()
          vim.cmd([[ execute "normal! \<ESC>" ]]) -- Force exit from visual mode
          vim.api.nvim_win_set_cursor(0, { math.floor((vim.fn.line("'<") + vim.fn.line("'>")) / 2), 0 })
          vim.cmd([[ execute "normal! zz" ]])
        end
        keymap("x", "zz", CenterVisualSelection, { desc = "Center" })

        -- Remove default LSP mappings
        vim.keymap.del("n", "grt")
        vim.keymap.del("n", "grr")
        vim.keymap.del("n", "grn")
        vim.keymap.del("n", "gra")
        vim.keymap.del("n", "gri")

        -- LSP mappings
        keymap("n", "<C-n>", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "<C-e>", function()
          vim.diagnostic.open_float(0, { scope = "cursor" })
        end, { desc = "Diagnostics" })
        keymap("n", "gr", vim.lsp.buf.rename, { desc = "Rename" })

        -- https://github.com/ibhagwan/fzf-lua/wiki#lsp-single-result
        keymap("n", "go", function()
          fzf.lsp_definitions({ jump1 = true })
        end, { desc = "Goto definition" })
        keymap("n", "gO", function()
          fzf.lsp_references({ jump1 = true, includeDeclaration = false })
        end, { desc = "Goto references" })

        keymap("n", "<M-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
        keymap("n", "<M-e>", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

        -- LSP maappings for both normal and visual modes
        keymap({ "n", "x" }, "<leader>n", vim.lsp.buf.code_action, { desc = "Code action" })
        keymap({ "n", "x" }, "<leader>e", vim.lsp.buf.format, { desc = "Format" })

        -- Manually show completion menu for AI suggestions
        keymap({ "i" }, "<C-g>", require("blink.cmp").show, { desc = "Show" })

        -- A function to search for TODOs and more
        local function FindTodo()
        -- Based on treesitter
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm
        --stylua: ignore start
        local tags = {
          "TODO", "WIP", -- To-do
          "NOTE", "XXX", "INFO", "DOCS", "PERF", "TEST", -- Note
          "HACK", "WARNING", "WARN", "FIX", -- Warning
          "FIXME", "BUG", "ERROR", -- Danger
        }
          --stylua: ignore end

          -- From VS Code `todo-tree`'s default regex
          -- https://github.com/Gruntfuggly/todo-tree/issues/526
          local regexp = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*(" .. table.concat(tags, "|") .. ")"

          -- Actually initiate the search
          -- https://github.com/ibhagwan/fzf-lua/discussions/1194#discussioncomment-9418686
          fzf.grep({ no_esc = true, search = regexp, prompt = "> ", winopts = { title = "Find TODOs" } })
        end

        -- The great <leader> keymap
        wk.add({ { "<leader>", group = "Leader" } })

        -- The basics
        keymap("n", "<leader>w", "<cmd>w!<cr>", { desc = "Save" })
        keymap("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit" })
        keymap("n", "<leader>o", vim.cmd.nohl, { desc = "Nohl" })

        -- Make
        keymap("n", "<leader>m", "<cmd>make<cr>", { desc = "Make" })

        -- Search and replace
        keymap("n", "<leader>a", grug.open, { desc = "Search and replace" })
        keymap("x", "<leader>a", function()
          grug.open({ search = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))) })
        end, { desc = "Search and replace" })
        keymap("n", "<leader>A", function()
          grug.open({ prefills = { paths = vim.fn.expand("%") } })
        end, { desc = "Search and replace in current file" })
        keymap("x", "<leader>A", function()
          grug.open({
            search = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))),
            prefills = { paths = vim.fn.expand("%") },
          })
        end, { desc = "Search and replace in current file" })

        -- Search
        keymap("n", "<leader>r", fzf.resume, { desc = "Resume search" })
        keymap("n", "<leader>s", fzf.live_grep, { desc = "Search" })
        keymap("n", "<leader>t", fzf.files, { desc = "Files" })
        keymap("n", "<leader>x", fzf.lsp_document_symbols, { desc = "Symbols" })
        keymap("n", "<leader>d", fzf.diagnostics_workspace, { desc = "Diagnostics" })
        keymap("n", "<leader>f", FindTodo, { desc = "Find TODOs" })
        -- Search selected text in visual mode
        keymap("x", "<leader>s", function()
          fzf.live_grep({ search = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))) })
        end, { desc = "Search" })

        -- Copilot Chat
        keymap("n", "<leader>c", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })

        -- Undo tree
        keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })

        -- Plugins (group: `l`)
        wk.add({ { "<leader>l", group = "Plugins" } })
        keymap("n", "<leader>ll", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" })
        keymap("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })
        keymap("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Lazy Profile" })
        keymap("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })

        -- Git (group: `g`)
        wk.add({ { "<leader>g", group = "Git" } })
        keymap("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
        keymap("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git Diff" })
        keymap("n", "<leader>gf", "<cmd>G fetch<cr>", { desc = "Git Fetch" })
        keymap("n", "<leader>gm", "<cmd>G merge<cr>", { desc = "Git Merge" })
        keymap("n", "<leader>ga", "<cmd>G add %<cr>", { desc = "Git Add" })
        keymap("n", "<leader>gc", "<cmd>G commit<cr>", { desc = "Git Commit" })
        keymap("n", "<leader>gp", "<cmd>G push<cr>", { desc = "Git Push" })

        -- Git hunks (group: `h`)
        wk.add({ { "<leader>h", group = "Git hunks" } })
        keymap("n", "<leader>hd", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Diff hunk" })
        keymap("n", "<leader>hv", "<cmd>Gitsigns select_hunk<cr>", { desc = "Visual select hunk" })
        keymap("n", "<leader>hn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
        keymap("n", "<leader>hp", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
        keymap("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
        keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
        keymap("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })

        -- Interface (group: `i`)
        wk.add({ { "<leader>i", group = "Interface" } })
        keymap("n", "<leader>in", "<cmd>set number!<cr>", { desc = "Number" })
        keymap("n", "<leader>is", "<cmd>set spell!<cr>", { desc = "Spell" })
        keymap("n", "<leader>iw", "<cmd>set wrap!<cr>", { desc = "Wrap" })
        keymap("n", "<leader>ic", toggle_cursorline, { desc = "CursorLine" })
        keymap("n", "<leader>il", "<cmd>IBLToggle<cr>", { desc = "IndentLine" })
        keymap("n", "<leader>ib", toggle_background, { desc = "Background" })
      end,
    },

    -- Git
    { "tpope/vim-fugitive", event = "VeryLazy" },
    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = { signs_staged_enable = false },
    },

    -- Search and go to files
    {
      "ibhagwan/fzf-lua",
      event = "VeryLazy",
      opts = {
        defaults = {
          formatter = "path.filename_first",
          multiline = 2,
        },
        files = {
          fd_opts = "-t f -H -E '.git/'",
          cwd_prompt = false,
        },
        grep = {
          -- https://github.com/ibhagwan/fzf-lua/issues/971
          rg_opts = "--hidden -g '!.git/' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --trim -e",
        },
      },
      config = function(_, opts)
        local fzf = require("fzf-lua")

        if opts then
          fzf.setup(opts)
        end

        require("fzf-lua").register_ui_select()
      end,
    },

    -- Search and replace
    { "MagicDuck/grug-far.nvim", version = "*", event = "VeryLazy" },
  },
})

--------------
-- COMMANDS --
--------------

-- These are all custom commands to complete simple tasks

-- Copy the full path of currently open file to system clipboard
vim.api.nvim_create_user_command("CopyFilename", function()
  local filename = vim.fn.expand("%:p")
  vim.fn.setreg("+", filename)
  vim.notify(filename)
end, {})

-- Copy file content to clipboard
-- https://stackoverflow.com/q/15610222
vim.api.nvim_create_user_command("CopyFileContent", function()
  vim.api.nvim_command("%y+")
end, {})

-- Replace all the text in the buffer with that of the system clipboard.
-- Helpful when you have copied the text to somewhere else for modification and want to update back.
vim.api.nvim_create_user_command("ReplaceWithClipboard", function()
  vim.api.nvim_command("silent %delete _ | silent put + | 1delete")
end, {})

local function format_file_size(size)
  if size < 1024 then
    return string.format("%d bytes", size)
  elseif size < 1024 * 1024 then
    return string.format("%.2f KB", size / 1024)
  elseif size < 1024 * 1024 * 1024 then
    return string.format("%.2f MB", size / (1024 * 1024))
  else
    return string.format("%.2f GB", size / (1024 * 1024 * 1024))
  end
end

-- Check (and clear) the LSP log,
-- which could get too large sometimes
vim.api.nvim_create_user_command("CheckLspLog", function()
  local log_path = vim.fn.stdpath("state") .. "/lsp.log"

  local file = io.open(log_path, "r")
  if not file then
    vim.notify("LSP log file not found.")
    return
  end
  local size = file:seek("end")
  file:close()
  vim.notify("LSP log size: " .. format_file_size(size))

  -- Clear the LSP log (default is not)
  local confirm = vim.fn.confirm("Clear log file?", "&Yes\n&No", 2)
  if confirm == 1 then
    file = io.open(log_path, "w")
    if file then
      file:close()
    end
    vim.notify("LSP log cleared.")
  end
end, {})
