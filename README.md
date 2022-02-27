# Max's dotfiles

**Warning: very unstable, fork/use with care**

This repo is designed to be placed in `~/.config/`,
so you can just clone this repo to `~/.config/` with the following:<br>
(remember to do backup first if you already have a `~/.config/` folder)

```bash
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

Note: Ubuntu/Debian calls `fd` as `fdfind`, so this name is used throughout the config<br>
(On Arch/Manjaro: `fd`, on Fedora: `fd-find`)

If with tmux version < 3.1 (try `tmux -V`),
add a file `~/.tmux.conf`:
```tmux
# Use config in ~/.config/
source-file ~/.config/tmux/.tmux.conf
```

To remove the Windows path from the native WSL path,
add a file (or append to) `/etc/wsl.conf` with `sudo nano`:<br>
(Note that the Neovim `"+` and `"*` registers will stop being linked to the system clipboard,
since the CLI clipboard tool, `win32yank`, is on the Windows side of the path)
```
[interop]
appendWindowsPath = false
```
