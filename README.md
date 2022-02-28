# Max's dotfiles

**Warning: very unstable, fork/use with care**

## Quick start

If you are not `mhho3082`, then I would advise you to
fork this repo, look through the code, and remove the parts
you don't need; I can't ensure that my configs will fit your needs.

This repo is designed to be placed in `~/.config/`,
so to use it on your machine, just clone it:

```bash
# Do backup if needed
tar -cpzf "/home/$USER/config_backup.tar.gz" "/home/$USER/.config/"

# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

If you are having a clean install (say WSL), please:
1. Get Git working (to a bare minimum, at least)
2. Clone this repo
3. Work on installing and setting up other apps

For various frequently used commands and motions,
please see the folder `./tips/`.

## Features

* Numerous aliases - see `./fish/config.fish` and `./git/config`
* Bookmarks through `fzf` - call with `m`
  * Bookmarks file in `~/.cd_bookmarks`
* Powerful setup for Tmux and Neovim
  * Various powerful and ergonomic plugins for Neovim
  * Vim-like key remaps for Tmux - see `./tmux/.tmux.conf`
  * Minimalist UI
* Minimal setup
  * Set Fish as the default shell
  * Change the Git user (in `./git/config`) to yourselves
  * Sync Neovim's plugins
  * Log in to GitHub CLI

## App list

This is listed in the order of installation.
Those surrounded in brackets are found to be installed already in Ubuntu 20.04 LTS.
Appended data starting with `ppa:` is the PPA for Ubuntu.
If it is installed already and still have `ppa:` - it needs upgrading with the PPA.

<details>
<summary> App List </summary>

- (`tmux`)
- (`htop`)
- (`git`) (`ppa:git-core/ppa`)
- `unzip`
- `fish` (`ppa:fish-shell/release-3`)
- `exa` (`ppa:spvkgn/exa`)
- `fzf`
- `ripgrep`
- `fdfind`
- `gh` 
  ```
  $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
  $ sudo apt-add-repository https://cli.github.com/packages
  ```
- `nodejs`
  ```
  $ curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
  $ sudo apt-get install -y nodejs
  ```
- `npm`
- `python3-venv`
- `python3-pip`
- `neovim` (`ppa:neovim-ppa/stable`)
- `neovim` NodeJS module (`sudo npm install -g neovim`)
- (`pynvim`) Python module (`pip3 install --upgrade pynvim`)
- `clang`
- `clang-format`
- `llvm`
- `tldr` (`sudo npm install -g tldr`)

</details>

## Notes

To set fish as the default shell (from bash / zsh):

```bash
chsh -s `which fish`
```

To sync Neovim plugins (from the terminal):

```bash
nvim +PackerSync

# Or, if you have the fish alias running
n +PackerSync
```

(Weird) names for the `fd` tool:
- Ubuntu/Debian: `fdfind` (Used throughout the config) (for Ubuntu > v19.10)
- Arch/Manjaro: `fd`
- Fedora: `fd-find`

If with tmux version < 3.1 (check with `tmux -V`),
add a file `~/.tmux.conf`:

```tmux
# Use config in ~/.config/
source-file ~/.config/tmux/.tmux.conf
```

If you want to remove the Windows path from the native WSL path,
add a file with `sudo nano /etc/wsl.conf`:<br>
(Note that the Neovim `"+` and `"*` registers will stop being linked to the system clipboard,
since the CLI clipboard tool, `win32yank`, is on the Windows side of the path)

```
[interop]
appendWindowsPath = false
```

## Credits

- Git alias partly from
  https://github.com/mathiasbynens/dotfiles
- Tmux status bar based off of
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `m` bookmark function inspired by
  https://dmitryfrank.com/articles/shell_shortcuts
