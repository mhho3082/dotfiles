# Neovim tips

## Base setup

Default leader key: <kbd>Space</kbd>

Most custom and in-built key bindings, such as leader-led ones,
can be explored with the `which-key` pop-up.
You can also look at the `remap` section in `init.lua` for some reference.

Extended targets,
such as `va"` (visual select, around `"` quotation marks),
are enabled using the
[`mini.ai`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
plugin.

## In-built commands

- `<C-w>` + `[vs]` - split
- `<C-w>` + `[+-<>]` - resize windows

* `<C-v>` - visual block

(can be used for multi-cursor-like actions,
such as using `I` or `A` for adding text on multiple lines)

- `"+y` - yank to clipboard
- `"+p` - paste from clipboard

(Please install `xsel` or `xclip` if on Linux
for Neovim to access the X clipboard;
for other OSes, please refer to respective documentations)

* `:term` - Use current buffer for a terminal session
* `<C-\><C-n>` - Get out of terminal mode

## LSP-related commands

- `K` - Details
- `J` - Diagnostics

* `<C-j>` - Next diagnostics
* `<C-k>` - Previous diagnostics

- `gd` - Go to definition
- `gD` - Go to implementation
- `gr` - Rename

* `<Space>j` - Code action
* `<Space>k` - Format

## Plugin commands

[`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
- `<C-n>` / `<C-p>` - next / previous in autocomplete
- `<Tab>` - select autocomplete option / go to next field in snippet
  (acts as "super-tab")
- `<C-e>` - abort from autocomplete

[`mini.comment`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md)
- `gc` - comment a section (e.g., `gcip`)
- `gcc` - comment current line

[`mini.surround`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md)
- `sa` - surround add
- `sd` - surround delete
- `sr` - surround replace

[`nvim-gomove`](https://github.com/booperlv/nvim-gomove)
- `<A-[hjkl]>` - move selection
