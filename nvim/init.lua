-- Programs needed: unzip, ripgrep, fd

-- Programs advised:
-- `tree-sitter` (and `tree-sitter-cli`) for install-from-grammer syntax files, esp. latex
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
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", {})
    local v = vim.api.nvim_get_hl(0, { name = "CursorLineNR", link = false })
    v.bold = true
    vim.api.nvim_set_hl(0, "CursorLineNR", v)
  end,
})

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

-- Allow to read project-local configs
vim.opt.exrc = true

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
    -- For markdown inline block
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
    {
      "nvim-mini/mini.surround",
      event = "VeryLazy",
      opts = {
        custom_surroundings = {
          -- For laravel translated strings
          ["-"] = {
            input = { "{{__%('.-'%)}}", "^{{__%('().*()'%)}}$" },
            output = { left = "{{__('", right = "')}}" },
          },
        },
      },
    },
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
    -- Align
    { "nvim-mini/mini.align", event = "VeryLazy", opts = {} },
    -- Move code
    {
      "nvim-mini/mini.move",
      event = "VeryLazy",
      opts = {
        mappings = {
          left = "<S-Left>",
          right = "<S-Right>",
          down = "<S-Down>",
          up = "<S-Up>",

          line_left = "<S-Left>",
          line_right = "<S-Right>",
          line_down = "<S-Down>",
          line_up = "<S-Up>",
        },
      },
    },
    -- Multi-line f/t
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
    -- Easymotion
    {
      "nvim-mini/mini.jump2d",
      event = "VeryLazy",
      opts = {
        labels = "tsraneiogmdhpflu",
        view = { dim = true, n_steps_ahead = 1 },
        allowed_lines = { blank = false },
        mappings = { start_jumping = "S" },
      },
      config = function(_, opts)
        local jump2d = require("mini.jump2d")

        opts = vim.tbl_extend("force", {
          -- One or more [\w-_], containing at least one \w
          spotter = jump2d.gen_spotter.pattern("[%w_%-]*%w[%w_%-]*"),
        }, opts or {})

        if opts then
          jump2d.setup(opts)
        end
      end,
    },
    -- Trailspace
    { "nvim-mini/mini.trailspace", event = "VeryLazy", opts = {} },

    -- Readline-like insertion
    { "tpope/vim-rsi", event = "VeryLazy" },

    -- Indent
    { "tpope/vim-sleuth", event = "VeryLazy" },

    -- Splitjoin
    {
      "Wansmer/treesj",
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        use_default_keymaps = false,
      },
    },

    -- Pairs
    { "windwp/nvim-autopairs", event = "VeryLazy", opts = {} },
    { "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },

    -- File browser
    {
      "stevearc/oil.nvim",
      cond = not vim.g.vscode,
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
      cond = not vim.g.vscode,
      event = "VeryLazy",
      config = function()
        -- Open on the right
        vim.g.undotree_WindowLayout = 3
      end,
    },

    -- Move around better
    {
      "chrisgrieser/nvim-spider",
      event = "VeryLazy",
      config = function()
        local spider = require("spider")
        vim.tbl_map(function(ops)
          keymap({ "n", "v", "o", "x" }, ops, function()
            spider.motion(ops)
          end, { desc = "Spider-" .. ops })
        end, { "w", "e", "b", "ge" })
      end,
    },

    -- VIEW --

    -- Indent guide
    {
      "lukas-reineke/indent-blankline.nvim",
      cond = not vim.g.vscode,
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
      cond = not vim.g.vscode,
      lazy = false,
      priority = 1000,
      config = function()
        vim.opt.background = "dark"
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_better_performance = true
        vim.cmd.colorscheme("gruvbox-material")

        -- Function to brighten/dim a color
        local bit = require("bit")
        local function adjust_brightness(color, factor)
          local r = bit.band(bit.rshift(color, 16), 0xFF)
          local g = bit.band(bit.rshift(color, 8), 0xFF)
          local b = bit.band(color, 0xFF)
          factor = factor
          return bit.bor(
            bit.lshift(math.floor(r * factor), 16),
            bit.lshift(math.floor(g * factor), 8),
            math.floor(b * factor)
          )
        end

        -- Adjust the hl groups for `mini.jump2d` to be closer to `hop.nvim`
        -- (modifying https://github.com/sainnhe/gruvbox-material/blob/master/colors/gruvbox-material.vim#L1524)
        local v = vim.api.nvim_get_hl(0, { name = "MiniIconsBlue", link = false })
        v.bold = true
        v.nocombine = true
        vim.api.nvim_set_hl(0, "MiniJump2dSpot", v)
        vim.api.nvim_set_hl(0, "MiniJump2dSpotUnique", v)

        v.bold = false
        v.fg = adjust_brightness(v.fg, 0.7)
        vim.api.nvim_set_hl(0, "MiniJump2dSpotAhead", v)
      end,
    },

    -- Syntax highlight
    {
      "nvim-treesitter/nvim-treesitter",
      build = function()
        require("nvim-treesitter.install").update({})()
      end,
      event = "VeryLazy",
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

    -- Statusline and tabline
    {
      "nvim-lualine/lualine.nvim",
      cond = not vim.g.vscode,
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
          extensions = {
            "fugitive",
            "fzf",
            "lazy",
            "mason",
            {
              -- A modified version of
              -- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/extensions/oil.lua
              -- to work with ssh, see
              -- https://github.com/stevearc/oil.nvim/blob/1360be5fda9c67338331abfcd80de2afbb395bcd/doc/recipes.md?plain=1#L39
              sections = {
                lualine_a = {
                  function()
                    local ok, oil = pcall(require, "oil")
                    if ok then
                      local dir = oil.get_current_dir()
                      if dir then
                        return vim.fn.fnamemodify(dir, ":~")
                      else
                        -- If there is no current directory (e.g. over ssh), just show the buffer name
                        return vim.api.nvim_buf_get_name(0)
                      end
                    else
                      return ""
                    end
                  end,
                },
              },

              filetypes = { "oil" },
            },
          },
        })
      end,
    },

    -- Icons
    { "nvim-tree/nvim-web-devicons", event = "VeryLazy", opts = {} },

    -- Smear cursor, for screen sharing
    {
      "sphamba/smear-cursor.nvim",
      cond = not vim.g.vscode,
      event = "VeryLazy",
      opts = {
        -- Disable by default
        enabled = false,
        -- Fire hazard style, but neon
        cursor_color = "#8ec07c",
        stiffness = 0.5,
        trailing_stiffness = 0.25,
        damping = 0.75,
        trailing_exponent = 5,
        never_draw_over_target = true,
        hide_target_hack = true,
        gamma = 1,
      },
    },

    -- COPILOTS --

    -- Auto-complete
    {
      "saghen/blink.cmp",
      version = "*",
      cond = not vim.g.vscode,
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
      cond = not vim.g.vscode,
      event = "VeryLazy",
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = { markdown = true, yaml = true, help = true },
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
      cond = not vim.g.vscode,
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

        local _, treesj = pcall(require, "treesj")
        local _, oil = pcall(require, "oil")
        local _, fzf = pcall(require, "fzf-lua")
        local _, spectre = pcall(require, "spectre")
        local _, smear = pcall(require, "smear_cursor")
        local _, vscode = pcall(require, "vscode")

        -- Move cursor by display lines by default
        vim.tbl_map(function(ops)
          keymap({ "n", "v", "o", "x" }, ops, "g" .. ops)
        end, { "j", "k", "0", "^", "$", "<Down>", "<Up>" })

        -- Fix lua API keyboard interrupt issue
        keymap("i", "<C-c>", "<C-[>", { desc = "Escape" })

        if not vim.g.vscode then
          -- Open oil with -
          keymap({ "n" }, "-", oil.open, { desc = "Open oil.nvim" })

          -- Split/join lines
          keymap({ "n" }, "gs", treesj.split, { desc = "Split" })
          keymap({ "n" }, "gj", treesj.join, { desc = "Join" })
        end

        -- Add easy copy/paste to system clipboard
        keymap({ "n", "v" }, "gy", '"+y', { desc = "Copy to clipboard" })
        keymap({ "n", "v" }, "gY", '"+Y', { desc = "Copy to clipboard" })
        keymap({ "n", "v" }, "gp", '"+p', { desc = "Paste to clipboard" })
        keymap({ "n", "v" }, "gP", '"+P', { desc = "Paste to clipboard" })

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

        -- LSP mappings
        if not vim.g.vscode then
          keymap("n", "<C-n>", vim.lsp.buf.hover, { desc = "Hover" })
          keymap("n", "<C-e>", function()
            vim.diagnostic.open_float(0, { scope = "cursor" })
          end, { desc = "Diagnostics" })
          keymap("n", "gr", vim.lsp.buf.rename, { desc = "Rename" })

          keymap("n", "go", function()
            -- https://github.com/ibhagwan/fzf-lua/wiki#lsp-single-result
            fzf.lsp_definitions({ jump1 = true })
          end, { desc = "Goto definition" })
          keymap("n", "gO", function()
            fzf.lsp_references({
              jump1 = true,
              includeDeclaration = false,
            })
          end, { desc = "Goto references" })

          keymap("n", "<M-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          keymap("n", "<M-e>", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
        else
        --stylua: ignore start
        keymap("n", "<C-n>", function() vscode.action("editor.action.showHover") end, { desc = "Hover" })
        keymap("n", "gr", function() vscode.action("editor.action.rename") end, { desc = "Rename" })
        keymap("n", "go", function() vscode.action("editor.action.goToDefinition") end, { desc = "Goto definition" })
        keymap("n", "gO", function() vscode.action("editor.action.referenceSearch.trigger") end, { desc = "Goto references" })
          --stylua: ignore end
        end

        -- LSP maappings for both normal and visual modes
        keymap({ "n", "v" }, "<leader>n", vim.lsp.buf.code_action, { desc = "Code action" })
        keymap({ "n", "v" }, "<leader>e", vim.lsp.buf.format, { desc = "Format" })

        -- Manually show completion menu for AI suggestions
        keymap({ "i" }, "<C-g>", require("blink.cmp").show, { desc = "Show" })

        -- A function to search for TODOs and more
        local function FindTodo()
        -- Based on treesitter
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm
        --stylua: ignore start
        local tags = {
          -- To-do
          "TODO", "WIP",
          -- Note
          "NOTE", "XXX", "INFO", "DOCS", "PERF", "TEST",
          -- Warning
          "HACK", "WARNING", "WARN", "FIX",
          -- Danger
          "FIXME", "BUG", "ERROR",
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
        -- Basics
        keymap("n", "<leader>w", "<cmd>w!<cr>", { desc = "Save" })
        keymap("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit" })
        keymap("n", "<leader>o", vim.cmd.nohl, { desc = "Nohl" })
        -- Make
        if not vim.g.vscode then
          keymap("n", "<leader>b", "<cmd>OverseerRun<cr>", { desc = "Build" })
        else
        --stylua: ignore start
        keymap("n", "<leader>b", function() vscode.action("workbench.action.tasks.build") end, { desc = "Build" })
          --stylua: ignore end
        end
        if not vim.g.vscode then
          -- Search
          keymap("n", "<leader>a", fzf.lsp_document_symbols, { desc = "Symbols" })
          keymap("n", "<leader>r", fzf.resume, { desc = "Resume search" })
          keymap("n", "<leader>s", fzf.live_grep, { desc = "Search" })
          keymap("n", "<leader>t", fzf.files, { desc = "Files" })
          keymap("n", "<leader>d", fzf.diagnostics_workspace, { desc = "Diagnostics" })
          keymap("n", "<leader>f", FindTodo, { desc = "Find TODOs" })
          -- Search and Replace
          keymap("n", "<leader>p", spectre.toggle, { desc = "Search and Replace" })
          -- Undo tree
          keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
          -- Search selected text in visual mode
          keymap("v", "<leader>s", function()
            fzf.live_grep({ search = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))) })
          end, { desc = "Search" })
        else
        --stylua: ignore start
        keymap("n", "<leader>s", function() vscode.action("workbench.view.search") end, { desc = "Search" })
        keymap("n", "<leader>t", function() vscode.action("workbench.action.quickOpen") end, { desc = "Files" })
          --stylua: ignore end
        end
        -- Plugins (group: `l`)
        wk.add({ { "<leader>l", group = "Plugins" } })
        keymap("n", "<leader>ll", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" })
        keymap("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })
        keymap("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Lazy Profile" })
        keymap("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason" })
        if not vim.g.vscode then
          -- Git (group: `g`)
          wk.add({ { "<leader>g", group = "Git" } })
          keymap("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
          keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git Diff" }) -- Or `Gvdiffsplit`
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
        else
        --stylua: ignore start
        -- Git (group: `g`)
        keymap("n", "<leader>gb", function() vscode.action("gitlens.toggleLineBlame") end, { desc = "Git Blame" })
        keymap("n", "<leader>gd", function() vscode.action("gitlens.diffWithPrevious") end, { desc = "Git Diff" })
        keymap("n", "<leader>gf", function() vscode.action("git.fetch") end, { desc = "Git Fetch" })
        keymap("n", "<leader>gm", function() vscode.action("git.merge") end, { desc = "Git Merge" })
        keymap("n", "<leader>ga", function() vscode.action("git.stage") end, { desc = "Git Add" })
        keymap("n", "<leader>gc", function() vscode.action("git.commit") end, { desc = "Git Commit" })
        keymap("n", "<leader>gp", function() vscode.action("git.push") end, { desc = "Git Push" })
        -- Git hunks (group: `h`)
        keymap("n", "<leader>hn", function() vscode.action("gitlens.annotations.nextChange") end, { desc = "Next hunk" })
        keymap("n", "<leader>hp", function() vscode.action("gitlens.annotations.previousChange") end, { desc = "Previous hunk" })
          --stylua: ignore end
        end
        -- Interface (group: `i`)
        wk.add({ { "<leader>i", group = "Interface" } })
        keymap("n", "<leader>in", "<cmd>set number!<cr>", { desc = "Number" })
        keymap("n", "<leader>is", "<cmd>set spell!<cr>", { desc = "Spell" })
        keymap("n", "<leader>iw", "<cmd>set wrap!<cr>", { desc = "Wrap" })
        keymap("n", "<leader>il", "<cmd>IBLToggle<cr>", { desc = "Indentline" })
        keymap("n", "<leader>ib", function()
          vim.o.background = vim.o.background == "dark" and "light" or "dark"
        end, { desc = "Background" })
        keymap("n", "<leader>ic", "<cmd>SmearCursorToggle<cr>", { desc = "Smear cursor" })
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
    {
      "sindrets/diffview.nvim",
      cond = not vim.g.vscode,
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {},
    },

    -- Search...
    {
      "ibhagwan/fzf-lua",
      cond = not vim.g.vscode,
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

    -- ... and replace
    {
      "nvim-pack/nvim-spectre",
      cond = not vim.g.vscode,
      event = "VeryLazy",
      opts = {
        -- https://github.com/nvim-pack/nvim-spectre/issues/118#issuecomment-1531683211
        replace_engine = { ["sed"] = { cmd = "sed", args = { "-i", "", "-E" } } },
      },
    },

    -- Run commands
    {
      "stevearc/overseer.nvim",
      cond = not vim.g.vscode,
      event = "VeryLazy",
      opts = {},
    },
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
