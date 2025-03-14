-- Programs needed: unzip, ripgrep, fd

-- Programs advised:
-- `tree-sitter` (and `tree-sitter-cli`) for install-from-grammer syntaxes, esp. latex
-- `fswatch` to improve LSP file watching performance

-- Notes: (for particular LSP services)
-- `prettierd` requires that `nodejs` and `npm` be installed globally
-- `efm` requires that `go` be installed globally
-- `jdtls` (Java LSP) only works with projects

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
  -- EDIT --

  -- Swiss army knife ("mini.nvim")
  -- More targets
  { "echasnovski/mini.ai", event = "VeryLazy", opts = {} },
  -- Surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      custom_surroundings = {
        -- For laravel translated strings
        ["-"] = {
          input = { "{{__('" .. "().-()" .. "')}}" },
          output = { left = "{{__('", right = "')}}" },
        },
        ["_"] = {
          input = { "{{_('" .. "().-()" .. "')}}" },
          output = { left = "{{_('", right = "')}}" },
        },
      },
    },
  },
  -- Comments
  {
    "echasnovski/mini.comment",
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
  { "echasnovski/mini.align", event = "VeryLazy", opts = {} },
  -- Move code
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Disable using <M-_> for moving in normal mode
        -- To prevent colliding with inter-window movements
        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    },
  },
  -- Multi-line f/t
  {
    "echasnovski/mini.jump",
    event = "VeryLazy",
    opts = {
      -- Delay values (in ms) for different functionalities. Set any of them to
      -- a very big number (like 10^7) to virtually disable.
      delay = {
        -- Delay between jump and highlighting all possible jumps
        highlight = 10000000,

        -- Delay between jump and automatic stop if idle (no jump is done)
        idle_stop = 0,
      },
    },
  },

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
    config = function(_, opts)
      local tsj = require("treesj")

      if opts then
        tsj.setup(opts)
      end
      keymap({ "n" }, "gs", tsj.split, { desc = "Split" })
      keymap({ "n" }, "gj", tsj.join, { desc = "Join" })
    end,
  },

  -- Pairs
  { "windwp/nvim-autopairs", event = "VeryLazy", opts = {} },
  { "windwp/nvim-ts-autotag", event = "VeryLazy", opts = {} },

  -- File browser
  {
    "stevearc/oil.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      view_options = {
        show_hidden = true,
        -- Don't display "../"
        is_always_hidden = function(name, _)
          return name == ".."
        end,
      },
      delete_to_trash = true,
      watch_for_changes = true,
    },
    config = function(_, opts)
      local oil = require("oil")

      if opts then
        oil.setup(opts)
      end

      keymap({ "n" }, "-", oil.open, { desc = "Open oil.nvim" })
    end,
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
      vim.background = "dark"
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
          "markdown", "markdown_inline", "latex", "bibtex", "mermaid",
          -- Config
          "rasi", -- For rofi
          "yaml", "toml", "zathurarc",
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
  { "kyazdani42/nvim-web-devicons", event = "VeryLazy", opts = {} },

  -- COPILOTS --

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    config = function()
      require("copilot").setup({})
    end,
  },

  -- LSP
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim", event = "VeryLazy", opts = {} },
      { "neovim/nvim-lspconfig", event = "VeryLazy" },
      {
        "creativenull/efmls-configs-nvim",
        version = "v1.x.x", -- version is optional, but recommended
        event = "VeryLazy",
        dependencies = { "neovim/nvim-lspconfig" },
      },
      { "barreiroleo/ltex-extra.nvim", event = "VeryLazy" },
    },
    event = "VeryLazy",
    opts = {},
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

      -- Add additional capabilities supported by nvim-cmp
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Set up LSP server with CMP capabilities and additional settings.
      ---@param server_name string the LSP server name
      ---@param options? {settings?: table, on_attach?: function, [string]: any} the optional LSP server settings
      local function setup_lsp_server(server_name, options)
        require("lspconfig")[server_name].setup(vim.tbl_extend("force", {
          capabilities = cmp_capabilities,
        }, options or {}))
      end

      -- Setup all LSP servers installed by Mason
      require("mason-lspconfig").setup_handlers({
        -- Default handler
        function(server_name)
          setup_lsp_server(server_name)
        end,
        -- Specific handlers
        ["lua_ls"] = function()
          setup_lsp_server("lua_ls", {
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                runtime = { version = "LuaJIT" },
                format = { enable = false },
              },
            },
          })
        end,
        ["rust_analyzer"] = function()
          setup_lsp_server("rust_analyzer", {
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = { command = "clippy" },
                imports = { granularity = { group = "module" }, prefix = "self" },
                cargo = { buildScripts = { enable = true } },
                procMacro = { enable = true },
              },
            },
          })
        end,
        ["ltex"] = function()
          setup_lsp_server("ltex", {
            settings = {
              ltex = {
                --stylua: ignore start
                enabled = {
                  "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd", "context",
                  -- "html", "xhtml",
                },
                --stylua: ignore end
                language = "en-GB",
                --stylua: ignore start
                dictionary = {
                  ["en-GB"] = {
                    "neovim", "fzf", "ripgrep", "fd", "dotfiles", "zsh", "Hin", "ArchWiki", "newpage", "gruvbox",
                  },
                },
                --stylua: ignore end
              },
            },
            on_attach = function()
              require("ltex_extra").setup({
                load_langs = { "en-GB", "en-US" },
                init_check = true,
                path = ".ltex",
              })
            end,
          })
        end,
        ["jdtls"] = function()
          setup_lsp_server("jdtls", { settings = { java = { format = { enabled = false } } } })
        end,
        ["html"] = function()
          setup_lsp_server("html", {
            -- https://github.com/LazyVim/LazyVim/discussions/2159
            init_options = {
              provideFormatter = false,
            },
          })
        end,
        ["cssls"] = function()
          setup_lsp_server("cssls", {
            -- https://github.com/LazyVim/LazyVim/discussions/2159
            init_options = {
              provideFormatter = false,
            },
          })
        end,
        ["efm"] = function()
          -- Special null-ls-like LSP server
          -- Based on https://github.com/creativenull/efmls-configs-nvim#setup

          -- Use default settings
          local languages = vim.tbl_deep_extend("force", require("efmls-configs.defaults").languages(), {
            -- Add pretter_d to JS/CSS languages
            svelte = { require("efmls-configs.formatters.prettier_d") },
            typescript = { require("efmls-configs.formatters.prettier_d") },
            markdown = { require("efmls-configs.formatters.prettier_d") },
            javascriptreact = { require("efmls-configs.formatters.prettier_d") },
            typescriptreact = { require("efmls-configs.formatters.prettier_d") },
            html = { require("efmls-configs.formatters.prettier_d") },
            css = { require("efmls-configs.formatters.prettier_d") },
            sass = { require("efmls-configs.formatters.prettier_d") },
            scss = { require("efmls-configs.formatters.prettier_d") },
            json = { require("efmls-configs.formatters.prettier_d") },
            jsonc = { require("efmls-configs.formatters.prettier_d") },
            -- Use beautysh for shell scripts
            bash = { require("efmls-configs.formatters.beautysh") },
            sh = { require("efmls-configs.formatters.beautysh") },
            zsh = { require("efmls-configs.formatters.beautysh") },
            -- Enforce Python formatting with black
            python = { require("efmls-configs.formatters.black") },
            -- Format BibTex with bibtex-tidy
            -- https://github.com/FlamingTempura/bibtex-tidy/issues/143
            bib = {
              {
                formatCommand = "bibtex-tidy --v2 --no-backup --no-sort --sort-fields --no-escape",
                formatStdin = true,
              },
            },
            -- Format GLSL using clang-format (need .clang-format file)
            glsl = { require("efmls-configs.formatters.clang_format") },
            -- Format blade with blade-formatter
            blade = { require("efmls-configs.formatters.blade_formatter") },
          })

          setup_lsp_server("efm", {
            filetypes = vim.tbl_keys(languages),
            settings = { rootMarkers = { ".git/" }, languages = languages },
            init_options = { documentFormatting = true, documentRangeFormatting = true },
          })
        end,
      })
    end,
  },

  -- LSP server status
  {
    "j-hui/fidget.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = { progress = { ignore = { "ltex" }, display = { render_limit = 5, done_icon = "✓" } } },
  },

  -- Auto-complete
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "VeryLazy",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      { "zbirenbaum/copilot-cmp", opts = {} },
    },
    config = function()
      local cmp = require("cmp")

      local buffer_source = {
        name = "buffer",
        keyword_length = 4,
        option = {
          get_bufnrs = function()
            local buf = vim.api.nvim_get_current_buf()
            local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
            if byte_size > 1024 * 1024 then -- 1 Megabyte max
              return {}
            end
            return { buf }
          end,
        },
      }

      cmp.setup({
        enabled = function()
          -- Enable in command mode
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          end

          -- Disable in prompts (e.g., Telescope, fzf-lua)
          local in_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
          if in_prompt then
            return false
          end

          -- Disable in comments, unless using Copilot
          local copilot = require("lazy.core.config").plugins["copilot-cmp"]
          if not copilot then
            local context = require("cmp.config.context")

            if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
              return false
            end
          end

          return true
        end,
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          -- Prev
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          -- Next
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          -- Confirm
          ["<C-y>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Abort
          ["<C-e>"] = cmp.mapping.abort(),
        },
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp_signature_help" },
        }, { buffer_source }),
      })

      -- Command line autocomplete
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { buffer_source },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    -- Referencing https://github.com/rafamadriz/friendly-snippets/wiki
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "VeryLazy",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function(_, opts)
      local luasnip = require("luasnip")

      if opts then
        luasnip.config.setup(opts)
      end

      -- Mappings
      keymap({ "i", "v" }, "<C-l>", function()
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        end
      end, { desc = "LuaSnip jump" })
      keymap({ "i", "v" }, "<C-h>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { desc = "LuaSnip jump back" })

      require("luasnip.loaders.from_vscode").lazy_load({
        exclude = { "html", "all" },
      })

      -- enable standardized comments snippets
      luasnip.filetype_extend("typescript", { "tsdoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("python", { "pydoc" })
      luasnip.filetype_extend("rust", { "rustdoc" })
      luasnip.filetype_extend("cs", { "csharpdoc" })
      luasnip.filetype_extend("java", { "javadoc" })
      luasnip.filetype_extend("c", { "cdoc" })
      luasnip.filetype_extend("cpp", { "cppdoc" })
      luasnip.filetype_extend("php", { "phpdoc" })
      luasnip.filetype_extend("kotlin", { "kdoc" })
      luasnip.filetype_extend("ruby", { "rdoc" })
      luasnip.filetype_extend("sh", { "shelldoc" })
    end,
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

      local fzf
      local vscode
      if not vim.g.vscode then
        fzf = require("fzf-lua")
      else
        -- For vscode-neovim interop
        vscode = require("vscode")
      end

      -- Leader key
      vim.g.mapleader = " "

      -- Move cursor by display lines by default
      vim.tbl_map(function(ops)
        keymap({ "n", "v", "o", "x" }, ops, "g" .. ops)
        -- keymap({ "n", "v", "o", "x" }, "g" .. ops, ops)
      end, { "j", "k", "0", "^", "$", "<Down>", "<Up>" })

      -- Fix lua API keyboard interrupt issue
      keymap("i", "<C-c>", "<C-[>", { desc = "Escape" })

      -- Add easy copy/paste to system clipboard
      keymap({ "n", "v" }, "gy", '"+y', { desc = "Copy to clipboard" })
      keymap({ "n", "v" }, "gY", '"+Y', { desc = "Copy to clipboard" })
      keymap({ "n", "v" }, "gp", '"+p', { desc = "Paste to clipboard" })
      keymap({ "n", "v" }, "gP", '"+P', { desc = "Paste to clipboard" })

      -- Operate on windows with <M-_> in normal mode
      -- (<M-_> is used to move code in visual mode)
      vim.tbl_map(function(ops)
        keymap("n", "<M-" .. ops .. ">", "<C-w>" .. ops)
      end, { "h", "j", "k", "l", "v", "s", "c" })

      -- LSP mappings
      if not vim.g.vscode then
        keymap("n", "N", vim.lsp.buf.hover, { desc = "Hover" })
        keymap("n", "E", function()
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

        keymap("n", "<C-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
        keymap("n", "<C-e>", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      else
        keymap("n", "N", function()
          vscode.action("editor.action.showHover")
        end, { desc = "Hover" })
        keymap("n", "gr", function()
          vscode.action("editor.action.rename")
        end, { desc = "Rename" })
        keymap("n", "go", function()
          vscode.action("editor.action.goToDefinition")
        end, { desc = "Goto definition" })
        keymap("n", "gO", function()
          vscode.action("editor.action.referenceSearch.trigger")
        end, { desc = "Goto references" })
      end

      -- LSP maappings for both normal and visual modes
      keymap({ "n", "v" }, "<leader>n", vim.lsp.buf.code_action, { desc = "Code action" })
      keymap({ "n", "v" }, "<leader>e", vim.lsp.buf.format, { desc = "Format" })

      -- A function to search for TODOs and more
      local function FindTodo()
        -- Based on treesitter
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm
        --stylua: ignore start
        local tags = {
          -- Todo
          "TODO", "WIP",
          -- Note
          "NOTE", "XXX", "INFO", "DOCS", "PERF", "TEST",
          -- Warning
          "HACK", "WARNING", "WARN", "FIX",
          -- Danger
          "FIXME", "BUG", "ERROR",
        }
        --stylua: ignore end

        -- From VS Code Todo Tree's default regex
        -- https://github.com/Gruntfuggly/todo-tree/issues/526
        local regexp = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*(" .. table.concat(tags, "|") .. ")"

        -- Actually initiate the search
        -- https://github.com/ibhagwan/fzf-lua/discussions/1194#discussioncomment-9418686
        fzf.grep({ no_esc = true, search = regexp, prompt = "Find TODOs> " })
      end

      -- The great <leader> keymap
      wk.add({ { "<leader>", group = "Leader" } })
      -- Basics
      keymap("n", "<leader>w", "<cmd>w!<cr>", { desc = "Save" })
      keymap("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit" })
      keymap("n", "<leader>o", vim.cmd.nohl, { desc = "Nohl" })
      -- Make
      keymap("n", "<leader>m", vim.cmd.make, { desc = "Make" })
      if not vim.g.vscode then
        -- Search
        keymap("n", "<leader>a", fzf.lsp_document_symbols, { desc = "Symbols" })
        keymap("n", "<leader>r", fzf.resume, { desc = "Resume search" })
        keymap("n", "<leader>s", fzf.live_grep, { desc = "Search" })
        keymap("n", "<leader>t", fzf.files, { desc = "Files" })
        keymap("n", "<leader>d", fzf.diagnostics_workspace, { desc = "Diagnostics" })
        keymap("n", "<leader>p", FindTodo, { desc = "Find TODOs" })
        -- Undo tree
        keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo tree" })
      end
      -- Lazy (group: l)
      wk.add({ { "<leader>l", group = "Lazy" } })
      keymap("n", "<leader>ll", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" })
      keymap("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Lazy Update" })
      keymap("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Lazy Profile" })
      -- Git (group: g)
      wk.add({ { "<leader>g", group = "Git" } })
      keymap("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
      keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git Diff" }) -- Or `Gvdiffsplit`
      keymap("n", "<leader>gf", "<cmd>G fetch<cr>", { desc = "Git Fetch" })
      keymap("n", "<leader>gm", "<cmd>G merge<cr>", { desc = "Git Merge" })
      keymap("n", "<leader>ga", "<cmd>G add %<cr>", { desc = "Git Add" })
      keymap("n", "<leader>gc", "<cmd>G commit<cr>", { desc = "Git Commit" })
      keymap("n", "<leader>gp", "<cmd>G push<cr>", { desc = "Git Push" })
      -- Git hunks (group: h)
      wk.add({ { "<leader>h", group = "Git hunks" } })
      keymap("n", "<leader>hd", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Diff hunk" })
      keymap("n", "<leader>hv", "<cmd>Gitsigns select_hunk<cr>", { desc = "Visual select hunk" })
      keymap("n", "<leader>hn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
      keymap("n", "<leader>hp", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
      keymap("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
      keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
      keymap("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
      -- Interface (group: i)
      wk.add({ { "<leader>i", group = "Interface" } })
      keymap("n", "<leader>in", "<cmd>set number!<cr>", { desc = "Number" })
      keymap("n", "<leader>is", "<cmd>set spell!<cr>", { desc = "Spell" })
      keymap("n", "<leader>iw", "<cmd>set wrap!<cr>", { desc = "Wrap" })
      keymap("n", "<leader>ii", "<cmd>IBLToggle<cr>", { desc = "Indentline" })
      keymap(
        "n",
        "<leader>ib",
        '<cmd>let &background = ( &background == "dark"? "light" : "dark" )<cr>',
        { desc = "Background" }
      )
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
      grep = {
        -- https://github.com/ibhagwan/fzf-lua/issues/971
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --trim -e",
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
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = {
            "-i",
            "",
            "-E",
          },
        },
      },
    },
    config = function(_, opts)
      local s = require("spectre")

      if opts then
        s.setup(opts)
      end

      keymap({ "n" }, "S", s.toggle, { desc = "Search and replace" })
    end,
  },

  -- Run commands
  {
    "tpope/vim-dispatch",
    cond = not vim.g.vscode,
    event = "VeryLazy",
  },
}, { ui = { backdrop = 100 } })

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
vim.opt.conceallevel = 2 -- For writing prose

-- Don't disturb me (by default)
vim.opt.number = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false

-- If number is on,
-- highlight current line number (but not the whole line)
-- https://stackoverflow.com/a/13275419
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", {})
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
  pattern = "javascript,typescript,json,jsonc,svelte,vue,html,css,scss,sass,lua,markdown",
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

--------------
-- COMMANDS --
--------------

-- These are all custom commands to complete simple tasks

-- Copy the full path of currently open file to system clipboard.
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
  local log_path = os.getenv("HOME") .. "/.local/state/nvim/lsp.log"

  local file = io.open(log_path, "r")
  if not file then
    vim.notify("LSP log file not found.")
    return
  end
  local size = file:seek("end")
  file:close()
  vim.notify("LSP log size: " .. format_file_size(size))

  -- Clear the log file (default is not)
  local confirm = vim.fn.confirm("Clear log file?", "&Yes\n&No", 2)
  if confirm == 1 then
    file = io.open(log_path, "w")
    if file then
      file:close()
    end
    vim.notify("LSP log cleared.")
  end
end, {})
