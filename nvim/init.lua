-- Warning:
-- If you have LSP server(s) running (which is usually), do not use `:source %`
-- It would create multiple LSP server instances and generate terrible lag

-- Programs needed:
-- unzip (for installation)
-- ripgrep & fd
-- python3, pip3, pynvim module
-- nodejs, npm, neovim module
-- gh

-------------
-- PLUGINS --
-------------

-- Auto-install packer
local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    Packer_bootstrap = vim.fn.system({
        'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path
    })
end

-- The great plugins list
require('packer').startup(function()
    -- Self-manage
    use 'wbthomason/packer.nvim'

    --  EDIT --

    --  Targets
    use 'wellle/targets.vim'

    -- Indent
    use 'tpope/vim-sleuth'

    --  Pairs
    use 'tpope/vim-surround'
    use 'cohama/lexima.vim'

    -- Align
    use 'junegunn/vim-easy-align'

    -- Move code
    use 'matze/vim-move'

    -- Auto-save
    use{
        'Pocco81/AutoSave.nvim',
        config = function()
            require("autosave").setup({
                enabled = true,
                execution_message = "",
            })
        end
    }

    --  Comments
    use {
        'tpope/vim-commentary',
    }

    --  VIEW --

    --  Indent guide
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_buftype_exclude = { 'terminal' }
        end,
    }

    --  Colorscheme
    use 'eddyekofo94/gruvbox-flat.nvim'

    --  Highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require("nvim-treesitter.configs").setup {
                highlight = {
                    -- false will disable the whole extension
                    enable = true,

                    -- list of language that will be disabled
                    disable = {},
                },
            }
        end
    }

    --  Statusline and tabline
    use 'nvim-lualine/lualine.nvim'

    --  Icons
    use {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require("nvim-web-devicons").setup {
                -- globally enable default icons (default to false)
                -- will get overriden by `get_icons` option
                default = true;
            }
        end
    }

    -- COPILOTS --

    --  LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'

    --  Auto-complete
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-path'
    use 'lukas-reineke/cmp-under-comparator'

    --  Snippets
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'

    --  Format
    use 'sbdchd/neoformat'

    -- Generate Markdown TOC
    use {
        'mzlogin/vim-markdown-toc',
        config = function()
            vim.g.vmt_cycle_list_item_markers = 1
        end,
    }

    --  COMMAND TOOLS --

    --  Command aid and remap
    use 'folke/which-key.nvim'

    --  Git
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '▁' },
                    topdelete    = { text = '▔' },
                    changedelete = { text = '~' },
                },
            })
        end
    }
    use 'rbong/vim-flog'
    use 'pwntester/octo.nvim'

    --  Search
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    --  Trees
    use {
        'kyazdani42/nvim-tree.lua',
        config = function()
            -- Highlights
            vim.g.nvim_tree_git_hl = 1

            -- Use proper cd
            vim.g.nvim_tree_respect_buf_cwd = 1

            require("nvim-tree").setup {
                disable_netrw = false,
                git = {
                    ignore = false,
                },
                view = {
                    side = 'right',
                },
                renderer = {
                    indent_markers = {
                        enable = true;
                    }
                }
            }
        end
    }
    use {
        'folke/trouble.nvim',
        config = function()
            require("trouble").setup {}
        end,
    }
    use {
        'mbbill/undotree',
        config = function()
            -- Open on the right
            vim.g.undotree_WindowLayout = 3
        end,
    }
    use {
        'liuchengxu/vista.vim',
        config = function()
            vim.g.vista_default_executive = 'nvim_lsp'
        end
    }

    --  Library for other plugins
    use 'nvim-lua/plenary.nvim'

    -- Auto-load all the above
    -- if packer is installed for the first time
    if Packer_bootstrap then
        require('packer').sync()
    end
end)

--------------
-- SETTINGS --
--------------

-- General settings
vim.opt.mouse = 'a'
vim.opt.title = true
vim.opt.hidden = true
vim.opt.linebreak = true
vim.opt.completeopt = 'menuone,noselect'

-- Default indent (sleuth overrides this if indent format found)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- No backup (auto-save instead)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Set split directions
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Persistence for undo history
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. "/undodir/"

-- Remove 'c no curly braces' errors
vim.g.c_no_curly_error = 1

-- Set spelling locale
vim.opt.spelllang = 'en_gb'

-- Set python path
if vim.loop.os_uname().sysname == "Windows-NT" then
    vim.g.python3_host_prog = 'python'
else
    vim.g.python3_host_prog = '/usr/bin/python3'
end

-- Lazy redraw
vim.opt.lazyredraw = true

-- Fix Markdown code block rendering issue
vim.g.markdown_minlines = 100

-- Add Markdown code block formatting to these languages
vim.g.markdown_fenced_languages = {
    'c', 'c++=cpp', 'make', 'cmake',
    'python', 'java', 'erb=eruby', 'ruby',
    'javascript', 'js=javascript', 'json=javascript', 'typescript',
    'bash=sh', 'fish=sh', 'zsh', 'conf',
    'html', 'css',
    'toml', 'yaml',
}

------------
-- REMAPS --
------------

local wk = require("which-key")

-- Setup which-key
wk.setup {
    plugins = {
        spelling = {
            enabled = true,
        },
    },
    layout = {
        align = "center",
    },
}

-- Leader key
vim.g.mapleader = ' '

-- Setups that which-key advices
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 0

-- Fix lua API keyboard interrupt issue
wk.register({
    ["<C-c>"] = { "<C-[>", "escape" }
}, { mode = "i" })

-- Name the comment motions
wk.register({
    ["gb"] = { "Block Comment" },
    ["gc"] = { "Line Comment" },
}, { mode = "n" })
wk.register({
    ["gb"] = { "Block Comment" },
    ["gc"] = { "Line Comment" },
}, { mode = "x" })

-- Use EasyaAlign with ga (e.g., vipga..., gaip...)
wk.register({ ["ga"] = { "<Plug>(EasyAlign)", "EasyAlign" } }, { mode = "n" })
wk.register({ ["ga"] = { "<Plug>(EasyAlign)", "EasyAlign" } }, { mode = "x" })

-- LSP mappings
wk.register({
    ["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover Info" },
    ["J"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Hover Issue" },
    ["gr"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Goto definition" },
    ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto declaration" },
}, { mode = "n" })

-- The great <leader> remap
wk.register({
    ["<leader>"] = {
        name = "leader",
        f = {
            name = "find",
            f = { "<cmd>Telescope find_files<cr>", "files" },
            g = { "<cmd>Telescope git_files<cr>", "git files" },
            r = { "<cmd>Telescope oldfiles<cr>", "recents" },
            b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "buffer" },
            s = { "<cmd>Telescope live_grep<cr>", "search" },
            c = { "<cmd>Telescope commands<cr>", "commands" },
            t = { "/\\(TODO:\\|FIX:\\|FIXME:\\|NOTE:\\|BUG:\\|TEMP:\\|HACK:\\|XXX:\\)<cr>", "todo" },
        },
        w = {
            name = "sidebars",
            d = { "<cmd>NvimTreeToggle<cr>", "directory" },
            u = { "<cmd>UndotreeToggle<cr>", "undo" },
            p = { "<cmd>TroubleToggle<cr>", "problems" },
            v = { "<cmd>Vista!!<cr>", "vista" },
        },
        p = {
            name = "packer",
            p = { "<cmd>PackerSync<cr>", "sync" },
            s = { "<cmd>PackerStatus<cr>", "status" },
        },
        g = {
            name = "git",
            -- Statuses
            s = { "<cmd>Floggit<cr>", "status" },
            g = { "<cmd>Flogsplit<cr>", "graph" },
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
            n = {"<cmd>set number!<cr>", "number"},
            s = {"<cmd>set spell!<cr>", "spell"},
            i = {"<cmd>IndentBlanklineToggle<cr>", "indentline"},
        },
        q = { "<cmd>qa!<cr>", "quit" },
        a = {
            ":let _s=@/ <Bar> :%s/\\s\\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <cr><cmd>Neoformat<cr>",
            "format"
        },
        c = {"<cmd>nohlsearch<cr>", "nohl"},
    },
})

-----------
-- THEME --
-----------

-- Basic settings
vim.g.termguicolors = true
vim.g.updatetime = 100
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.signcolumn = 'yes:2'

-- Don't disturb me
vim.opt.number = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.cursorline = false

-- Gruvbox theme
vim.g.gruvbox_transparent = true
vim.g.gruvbox_sidebars = { "qf", "vista_kind", "terminal", "undotree", "Trouble", "floggraph", "Outline" }

vim.cmd [[colorscheme gruvbox-flat]]

---------------
-- TELESCOPE --
---------------

local actions = require("telescope.actions")

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "-H", "-I", "-E", "CVS", "-E", "*.*.package", "-E", ".svn", "-E", ".git", "-E", ".hg", "-E", "node_modules", "-E", "bower_components", "-E", "*.c.o", "-E", "*.c.d"}
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
    }
}

require('telescope').load_extension('fzf')

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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Register a handler that will be called for each installed server when it's ready
-- (i.e. when installation is finished
--  or if the server is already installed).
require("nvim-lsp-installer").on_server_ready(function(server)
    local opts = {}

    opts.capabilities = capabilities

    -- Get sumneko_lua to understand init.lua
    if server.name == "sumneko_lua" then
        opts.settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim', 'use' }
                },
                runtime = {
                    version = "LuaJIT"
                }
            }
        }
    end

    -- Use British English for prose
    if server.name == "ltex" then
        opts.settings = {
            ltex = {
                language = 'en-GB',
                dictionary = {
                    ['en-GB'] = {
                        "neovim",
                        "fzf", "ripgrep", "fd",
                        "dotfiles", "zsh",
                        "Hin",
                    }
                }
            }
        }
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

---------
-- CMP --
---------

local cmp = require("cmp")

require("luasnip.loaders.from_vscode").load()

cmp.setup {
    enabled = function()
        local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
        if in_prompt then -- this will disable cmp in the Telescope window
            return false
        end

        local context = require("cmp.config.context")
        if context.in_treesitter_capture("comment") == true
            or context.in_syntax_group("Comment") then
            return false
        end

        if context.in_treesitter_capture("string") == true
            or context.in_syntax_group("String") then
            return false
        end

        return true
    end,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-e>"] = cmp.mapping.close(),
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
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = 'path' },
        { name = "nvim_lua" },
    },
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require "cmp-under-comparator".under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
}

-------------
-- LUALINE --
-------------

-- Boot up lualine
require('lualine').setup {
    options = { section_separators = '', component_separators = '' },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            { 'branch', icon = '' },
            { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' } }
        },
        lualine_c = {
            { 'filename', path = 1, symbols = { modified = '' } },
            { 'diagnostics', sources = { 'nvim_lsp' } }
        },
        lualine_x = { 'filetype', 'fileformat', 'encoding', '%l:%2c' },
        lualine_y = {},
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1, symbols = { modified = '' } } },
        lualine_x = { { 'filetype', colored = false } },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = { 'nvim-tree', 'fugitive' },
}
