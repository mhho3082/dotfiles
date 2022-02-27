# Dotfiles

**Warning: very unstable, fork/use with care**

If with tmux version < 3.1 (try `tmux -V`),
add a file `~/.tmux.conf`:
```
source-file ~/.config/tmux/.tmux.conf
```

To avoid Windows paths from polluting the WSL path,
add a file (or append to) `/etc/wsl.conf` with `sudo nano`:
```
[interop]
appendWindowsPath = false
```
