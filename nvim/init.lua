-- Programs required: `git`, `tree-sitter-cli`, `fd`, `ripgrep`

-- Notes: (for particular LSP services)
-- `prettierd` requires that `nodejs` and `npm` be installed globally
-- `jdtls` (Java LSP) only works with projects

-- Speed up require()
vim.loader.enable()

-- Prepare for checking startup time
local pf_config_start = vim.loop.hrtime()

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
vim.opt.updatetime = 100
vim.opt.conceallevel = 0

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

-- Toggle status column (disabled until entering new buffer or file)
vim.opt.signcolumn = "no"
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "FilterReadPost", "FileReadPost" }, {
  once = true,
  callback = function()
    vim.opt.signcolumn = "yes"
  end,
})
local function toggle_signcolumn()
  vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
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
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
-- Tab default indents
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "make,just",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end,
})

-- Ignore editorconfig
-- Resolves trailing whitespace auto-removed on save
vim.g.editorconfig = false

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
vim.g.markdown_minlines = 500

-- Add filetypes
vim.filetype.add({ pattern = { [".env.*"] = "config" } })

-- Make pyright and basedpyright use the correct pyenv version if provided
-- https://stackoverflow.com/a/78916731
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  once = true,
  callback = vim.schedule_wrap(function()
    if vim.fn.executable("pyenv") == 1 then
      vim.env.PYENV_VERSION = vim.trim(vim.fn.system("pyenv version-name"))
      vim.cmd("lsp restart")
    end
  end),
})

-----------------
-- COLORSCHEME --
-----------------

vim.pack.add({ { src = "https://github.com/sainnhe/gruvbox-material" } })
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = true
vim.cmd.colorscheme("gruvbox-material")

----------------
-- STATUSLINE --
----------------

-- Global statusline and hidden command line
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

-- Based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/utils/mode.lua
local function statusline_mode()
  local map = {
    ["n"] = "NORMAL",
    ["no"] = "O-PENDING",
    ["nov"] = "O-PENDING",
    ["noV"] = "O-PENDING",
    ["no\22"] = "O-PENDING",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["nt"] = "NORMAL",
    ["ntT"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "V-LINE",
    ["Vs"] = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    ["s"] = "SELECT",
    ["S"] = "S-LINE",
    ["\19"] = "S-BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rvc"] = "V-REPLACE",
    ["Rvx"] = "V-REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "EX",
    ["ce"] = "EX",
    ["r"] = "REPLACE",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERMINAL",
  }
  local hl_map = {
    ["COMMAND"] = "MiniStatuslineModeCommand",
    ["EX"] = "MiniStatuslineModeCommand",
    ["INSERT"] = "MiniStatuslineModeInsert",
    ["NORMAL"] = "MiniStatuslineModeNormal",
    ["REPLACE"] = "MiniStatuslineModeReplace",
    ["V-REPLACE"] = "MiniStatuslineModeReplace",
    ["VISUAL"] = "MiniStatuslineModeVisual",
    ["V-LINE"] = "MiniStatuslineModeVisual",
    ["V-BLOCK"] = "MiniStatuslineModeVisual",
    ["SELECT"] = "MiniStatuslineModeVisual",
    ["S-LINE"] = "MiniStatuslineModeVisual",
    ["S-BLOCK"] = "MiniStatuslineModeVisual",
  }
  local mode = vim.api.nvim_get_mode().mode
  mode = map[mode] or mode
  local hl = hl_map[mode] or "MiniStatuslineModeOther"
  return table.concat({ "%#" .. hl .. "#", " ", mode, " ", "%*" })
end

-- Based on https://vieitesss.github.io/posts/Neovim-custom-status-line/
local function statusline_git()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == "" then
    return ""
  end

  return table.concat({
    " [󰊢 ",
    git_info.head,
    git_info.added and git_info.added > 0 and (" +" .. git_info.added) or "",
    git_info.changed and git_info.changed > 0 and (" ~" .. git_info.changed) or "",
    git_info.removed and git_info.removed > 0 and (" -" .. git_info.removed) or "",
    "]",
  })
end

local function statusline_diagnostic()
  local levels = vim.diagnostic.severity
  local error = #vim.diagnostic.get(0, { severity = levels.ERROR }) or 0
  local warn = #vim.diagnostic.get(0, { severity = levels.WARN }) or 0
  local info = #vim.diagnostic.get(0, { severity = levels.INFO }) or 0
  local hint = #vim.diagnostic.get(0, { severity = levels.HINT }) or 0
  if error == 0 and warn == 0 and info == 0 and hint == 0 then
    return ""
  end

  return table.concat({
    " [LSP",
    error > 0 and " 󰅚 " .. error or "",
    warn > 0 and " 󰀪 " .. warn or "",
    info > 0 and " 󰋽 " .. info or "",
    hint > 0 and " 󰌶 " .. hint or "",
    "]",
  })
end

-- Based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/searchcount.lua
local function statusline_search()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, result = pcall(vim.fn.searchcount, { maxcount = 99, timeout = 500 })
  if not ok or next(result) == nil then
    return ""
  end

  -- Based on Neovim help files
  local format = " [%d/%d]"
  if result.incomplete == 1 then
    format = " [?/??]"
  elseif result.incomplete == 2 then
    format = result.current > result.maxcount and " [>%d/>%d]" or " [%d/>%d]"
  end
  return string.format(format, result.current, result.total)
end

-- Ideas from Neovim docs and https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
function Statusline()
  local parts = {
    statusline_mode(),
    " %<%f",
    "%( [%M%R%H]%)",
    "%#MiniStatuslineFilename#",
    statusline_git(),
    statusline_diagnostic(),
    "%*",
    "%=",

    "%#MiniStatuslineFilename#",
    " " .. vim.lsp.status(),
    " %{&filetype}",
    "%#warningmsg#",
    vim.bo.ff == "unix" and "" or " format:" .. vim.bo.ff,
    (vim.bo.fenc == "utf-8" or vim.bo.fenc == "") and "" or " encoding:" .. vim.bo.fenc,
    "%* ",

    "%#MiniStatuslineFileinfo#",
    statusline_search(),
    " %p%% %l:%c 0x%02B ",
    "%*",
  }
  return table.concat(parts, "")
end

vim.opt.statusline = "%{%v:lua.Statusline()%}"

-- Based on https://theopark.me/blog/2025-06-08-statusline-notes/
vim.api.nvim_create_autocmd({
  "SafeState",
  "LspAttach",
  "LspDetach",
  "LspProgress",
  "DiagnosticChanged",
}, {
  group = vim.api.nvim_create_augroup("StatuslineUpdate", { clear = true }),
  pattern = "*",
  callback = vim.schedule_wrap(function()
    vim.cmd.redrawstatus()
  end),
  desc = "Update statusline/winbar",
})

-- Enter async to avoid blocking UI during plugin startup
vim.schedule(function()
  -------------
  -- PLUGINS --
  -------------

  -- The great plugins list
  vim.pack.add({
    -- Library
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    -- Editing
    { src = "https://github.com/nvim-mini/mini.ai" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    { src = "https://github.com/nvim-mini/mini.align" },
    { src = "https://github.com/nvim-mini/mini.comment" },
    { src = "https://github.com/nvim-mini/mini.trailspace" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/tpope/vim-sleuth" },
    -- Movement
    { src = "https://github.com/chrisgrieser/nvim-spider" },
    { src = "https://github.com/tpope/vim-rsi" },
    -- File browser
    { src = "https://github.com/stevearc/oil.nvim" },
    -- Hinting
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    { src = "https://github.com/fang2hou/blink-copilot" },
    { src = "https://github.com/nvim-mini/mini.clue" },
    -- Copilot Chat
    { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
    -- Git
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    -- Search
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/MagicDuck/grug-far.nvim", version = vim.version.range("*") },
    -- LSP
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/nvimtools/none-ls.nvim" },
    -- Highlight
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
    -- Icons
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  })

  -- UI
  require("nvim-web-devicons").setup({})
  require("ibl").setup({ indent = { char = "│" }, scope = { enabled = false } })

  -- Editing packages
  require("mini.ai").setup({})
  require("mini.surround").setup({})
  require("mini.align").setup({})
  require("mini.trailspace").setup({})
  require("mini.comment").setup({
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  })
  require("nvim-autopairs").setup({})
  require("nvim-ts-autotag").setup({})

  -- Git
  require("gitsigns").setup({ current_line_blame_formatter = "- [<abbrev_sha>] <author>, <author_time:%R> - <summary>" })

  -- File editor
  require("oil").setup({
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _)
        return name == ".."
      end,
    },
    win_options = { wrap = true },
    delete_to_trash = true,
    watch_for_changes = true,
  })

  -- Fuzzy Finder
  require("fzf-lua").setup({
    files = {
      formatter = "path.filename_first",
      multiline = 2,
      fd_opts = "-t f -H -E '.git/'",
      cwd_prompt = false,
    },
    grep = {
      formatter = "path.filename_first",
      multiline = 2,
      -- https://github.com/ibhagwan/fzf-lua/issues/971
      rg_opts = "--hidden -g '!.git/' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --trim -e",
    },
    lsp = { formatter = "path.filename_first", multiline = 2 },
  })
  require("fzf-lua").register_ui_select()

  -- Function to find and remove all unused packages
  vim.api.nvim_create_user_command("PackClean", function()
    local packages = vim.tbl_map(
      function(v)
        return v.spec.name
      end,
      vim.tbl_filter(function(v)
        return not v.active
      end, vim.pack.get())
    )
    local confirm = vim.fn.confirm(
      string.format("Packages: %s\nRemove unused packages?", vim.iter(packages):join(", ")),
      "&Yes\n&No",
      2
    )
    if confirm == 1 then
      vim.pack.del(packages)
    end
  end, { desc = "Remove unused packages" })

  ----------------
  -- TREESITTER --
  ----------------

  -- Check if `tree-sitter` CLI is installed on system
  vim.api.nvim_create_user_command("InstallCommonTSParsers", function()
    if vim.fn.executable("tree-sitter") == 1 then
      --stylua: ignore start
      local languages = {
        -- Programming
        "c", "cpp", "make", "python", "java", "rust",
        "javascript", "typescript", "jsdoc", "vue", "svelte",
        -- Scripting
        "regex", "bash", "zsh", "sql",
        "html", "css", "scss", "json",
        "php", "php_only", "phpdoc", "blade", "twig",
        -- Git
        "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "diff",
        -- Prose
        "markdown", "markdown_inline", "bibtex", "mermaid",
        -- Config
        "rasi", -- For rofi
        "yaml", "toml", "zathurarc", "xresources",
        -- Vim-specific
        "vim", "vimdoc", "comment", "lua", "luadoc",
      }
      --stylua: ignore end
      require("nvim-treesitter").install(languages)
    else
      vim.api.nvim_echo(
        { { "Error: tree-sitter CLI is not installed. Please install it to use nvim-treesitter.", "ErrorMsg" } },
        true,
        {}
      )
    end
  end, { desc = "Install common tree-sitter parsers" })

  -- Based on https://github.com/MeanderingProgrammer/treesitter-modules.nvim#implementing-yourself
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter.setup", {}),
    callback = function(args)
      local buf = args.buf
      local filetype = args.match

      local language = vim.treesitter.language.get_lang(filetype) or filetype
      if not vim.treesitter.language.add(language) then
        return
      end

      vim.treesitter.start(buf, language)

      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  ------------------
  -- AUTOCOMPLETE --
  ------------------

  require("blink.cmp").setup({
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
  })

  -- Copilot chat
  -- https://copilotc-nvim.github.io/CopilotChat.nvim/#/?id=configuration
  require("CopilotChat").setup({ model = "gpt-5.2", temperature = 0.1, window = { layout = "vertical", width = 0.5 } })

  -------------
  -- KEYMAPS --
  -------------

  -- Leader key
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- A quick function to set keymaps;
  -- see https://neovim.io/doc/user/lua.html#vim.keymap.set()
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param options? table
  local function keymap(mode, lhs, rhs, options)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { noremap = true, silent = true }, options or {}))
  end

  local spider = require("spider")
  local oil = require("oil")
  local fzf = require("fzf-lua")
  local grug = require("grug-far")

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
  local function center_visual_selection()
    vim.cmd([[ execute "normal! \<ESC>" ]]) -- Force exit from visual mode
    vim.api.nvim_win_set_cursor(0, { math.floor((vim.fn.line("'<") + vim.fn.line("'>")) / 2), 0 })
    vim.cmd([[ execute "normal! zz" ]])
  end
  keymap("x", "zz", center_visual_selection, { desc = "Center" })

  -- Remove default LSP mappings
  pcall(vim.keymap.del, "n", "grt")
  pcall(vim.keymap.del, "n", "grr")
  pcall(vim.keymap.del, "n", "grn")
  pcall(vim.keymap.del, "n", "grx")
  pcall(vim.keymap.del, "n", "gra")
  pcall(vim.keymap.del, "n", "gri")

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

  keymap("n", "<M-n>", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next diagnostic" })
  keymap("n", "<M-e>", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Prev diagnostic" })

  -- LSP maappings for both normal and visual modes
  keymap({ "n", "x" }, "<leader>n", vim.lsp.buf.code_action, { desc = "Code action" })
  keymap({ "n", "x" }, "<leader>e", vim.lsp.buf.format, { desc = "Format" })

  -- Manually show completion menu for AI suggestions
  keymap({ "i" }, "<C-g>", require("blink.cmp").show, { desc = "Show" })

  -- A function to search for TODOs and more
  local function find_todo()
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

  local function toggle_nonascii_hl()
    local w = vim.w
    if w._nonascii then
      pcall(vim.fn.matchdelete, w._nonascii)
      w._nonascii = nil
    else
      w._nonascii = vim.fn.matchadd("MiniTrailspace", "[^\\x00-\\x7F]")
    end
  end

  -- The basics
  keymap("n", "<leader>w", "<cmd>silent w<cr>", { desc = "Save" })
  keymap("n", "<leader>q", "<cmd>silent qa!<cr>", { desc = "Quit" })
  keymap("n", "<leader>o", vim.cmd.nohl, { desc = "Nohlsearch" })

  -- Make
  keymap("n", "<leader>m", "<cmd>make<cr>", { desc = "Make" })

  -- Search and replace
  keymap("n", "<leader>a", grug.open, { desc = "Replace" })
  keymap("x", "<leader>a", function()
    grug.with_visual_selection()
  end, { desc = "Replace" })
  keymap("n", "<leader>A", function()
    grug.open({ prefills = { paths = vim.fn.expand("%") } })
  end, { desc = "Replace in current file" })
  keymap("x", "<leader>A", function()
    grug.with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
  end, { desc = "Replace in current file" })

  -- Search
  keymap("n", "<leader>r", fzf.resume, { desc = "Resume search" })
  keymap("n", "<leader>s", fzf.live_grep, { desc = "Search" })
  keymap("n", "<leader>t", fzf.files, { desc = "Files" })
  keymap("n", "<leader>x", fzf.lsp_document_symbols, { desc = "Symbols" })
  keymap("n", "<leader>d", fzf.diagnostics_workspace, { desc = "Diagnostics" })
  keymap("n", "<leader>f", find_todo, { desc = "Find TODOs" })
  -- Search selected text in visual mode
  keymap("x", "<leader>s", function()
    fzf.live_grep({ search = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))) })
  end, { desc = "Search" })

  -- Copilot Chat
  keymap("n", "<leader>c", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })

  -- Plugins (group: `p`)
  keymap("n", "<leader>pu", function()
    vim.pack.update()
  end, { desc = "Pack update" })
  keymap("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason" })

  -- Git (group: `g`)
  keymap("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
  keymap("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
  keymap("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git Diff" })
  keymap("n", "<leader>gf", "<cmd>G fetch<cr>", { desc = "Git Fetch" })
  keymap("n", "<leader>gm", "<cmd>G merge<cr>", { desc = "Git Merge" })
  keymap("n", "<leader>ga", "<cmd>G add %<cr>", { desc = "Git Add" })
  keymap("n", "<leader>gc", "<cmd>G commit<cr>", { desc = "Git Commit" })
  keymap("n", "<leader>gp", "<cmd>G push<cr>", { desc = "Git Push" })

  -- Git hunks (group: `h`)
  keymap("n", "<leader>hd", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Diff hunk" })
  keymap("n", "<leader>hv", "<cmd>Gitsigns select_hunk<cr>", { desc = "Visual select hunk" })
  keymap("n", "<leader>hn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
  keymap("n", "<leader>hp", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous hunk" })
  keymap("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
  keymap("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
  keymap("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })

  -- Interface (group: `i`)
  keymap("n", "<leader>in", "<cmd>set number!<cr>", { desc = "Number" })
  keymap("n", "<leader>iw", "<cmd>set wrap!<cr>", { desc = "Wrap" })
  keymap("n", "<leader>il", "<cmd>IBLToggle<cr>", { desc = "Indentline" })
  keymap("n", "<leader>ic", toggle_cursorline, { desc = "Cursorline" })
  keymap("n", "<leader>is", toggle_signcolumn, { desc = "Sign column" })
  keymap("n", "<leader>ia", toggle_nonascii_hl, { desc = "HL non-ASCII" })
  keymap("n", "<leader>ib", toggle_background, { desc = "Background" })

  -- Based on https://github.com/nvim-mini/mini.clue/blob/main/doc/mini-clue.txt
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = { delay = 200 },
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" },
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "i", keys = "<C-x>" },
      { mode = { "n", "x" }, keys = "g" },
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },
      { mode = "n", keys = "<C-w>" },
      { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })

  ---------
  -- LSP --
  ---------

  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚",
        [vim.diagnostic.severity.WARN] = "󰀪",
        [vim.diagnostic.severity.INFO] = "󰋽",
        [vim.diagnostic.severity.HINT] = "󰌶",
      },
    },
  })

  require("mason").setup({})
  require("mason-lspconfig").setup({ ensure_installed = { "copilot" } })

  local _, blink = pcall(require, "blink.cmp")
  if blink then
    vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
  end

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
  -- https://github.com/LazyVim/LazyVim/discussions/2159
  vim.lsp.config("html", { init_options = { provideFormatter = false } })
  vim.lsp.config("cssls", { init_options = { provideFormatter = false } })
end)

-------------------------
-- STARTUP PERFORMANCE --
-------------------------

local pf_config_done = vim.loop.hrtime()
local pf_config_schedule_done = 0
vim.schedule(function()
  pf_config_schedule_done = vim.loop.hrtime()
end)

vim.api.nvim_create_user_command("StartupTime", function()
  local time_to_config = (pf_config_done - pf_config_start) / 1e6
  local time_to_schedule = (pf_config_schedule_done - pf_config_done) / 1e6
  local time_total = (pf_config_schedule_done - pf_config_start) / 1e6
  print(
    string.format(
      "- Time to config: %.2fms\n- Time to schedule: %.2fms\n- Total time: %.2fms",
      time_to_config,
      time_to_schedule,
      time_total
    )
  )
end, { desc = "Show startup performance" })
