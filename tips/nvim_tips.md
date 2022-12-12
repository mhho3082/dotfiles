## Base setup

Default leader key: <kbd>Space</kbd>

(most key bindings, such as leader-led ones,
can be explored with the `which-key` pop-up)

Extended targets,
such as `va"` (visual select, around `"` quotation marks),
are enabled using the
[`mini.ai`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
plugin.

### In-built commands

- `<C-w>` + `[vs]` - split
- `<C-w>` + `[+-<>]` - resize windows

* `<C-v>` - visual block

- `"+y` - yank to clipboard
- `"+p` - paste from clipboard

(Please install `xsel` or `xclip` if on Linux
for Neovim to access the X clipboard;
for other OSes, please refer to respective documentations)

* `:term` - Turn current split into terminal buffer
* `<C-\><C-n>` - Get out of terminal mode

### LSP-related commands

- `K` - Details
- `J` - Diagnostics

* `<C-j>` - Next diagnostics
* `<C-k>` - Previous diagnostics

- `gd` - Go to definition
- `gD` - Go to implementation
- `gr` - Rename

* `<Space>j` - Code action
* `<Space>k` - Format

### Plugin commands

[`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
- `<C-n>` / `<C-p>` - next / previous (in autocomplete)

[`mini.comment`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md)
- `gc` - comment (line)

[`mini.surround`](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md)
- `sa` - surround add
- `sd` - surround delete
- `sr` - surround replace

[`nvim-gomove`](https://github.com/booperlv/nvim-gomove)
- `<A-[hjkl]>` - move selection
