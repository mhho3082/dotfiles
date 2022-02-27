# Max's dotfiles

**Warning: very unstable, fork/use with care**

All files in this repo is designed to be placed in `~/.config/`,
so you can just clone this repo to `~/.config/` with the following:
(remember to do backup first if you already have a `~/.config/` folder)

```bash
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

If with tmux version < 3.1 (try `tmux -V`),
add a file `~/.tmux.conf`:
```
source-file ~/.config/tmux/.tmux.conf
```

To avoid Windows paths from polluting the WSL path,
add a file (or append to) `/etc/wsl.conf` with `sudo nano`:
(Note that neovim `"+` and `"*` registers will stop working)
```
[interop]
appendWindowsPath = false
```
