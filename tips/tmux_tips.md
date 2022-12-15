# Tmux tips

## CLI arguments

- `tmux` - new session
- `tmux new -s [name]` - new named session
- `tmux at -t [name]` - attach to session
- `tmux ls` - list sessions

## Prefix-based key-bindings

* `<prefix>` = `<C-a>` (can change)

- `<prefix> w` - list sessions (and windows)
- `<prefix> d` - detach session

* `<prefix> c` - new window
* `<prefix> n/p` - next/previous window
* `<prefix> l` - previous selected window
* `<prefix> ,` - rename window
* `<prefix> .` - move window
* `<prefix> &` - kill window

- `<prefix> s` - split
- `<prefix> v` - vertical split
- `<prefix> o` - next pane
- `<prefix> hjkl` - change pane
- `<prefix> x` - Kill pane
- `<prefix> '{' / '}'` - swap with previous/next

## Copy mode

- `<prefix> [` - copy mode
- `q` - cancel
- `<space>` - begin selection
- `A` - append and cancel
- `D` - copy until end of line

## Status bar

- `<C-up> / <C-down>` - show/hide status bar
- `<C-left> / <C-right>` - go to window on left/right in status bar (i.e., previous/next)
