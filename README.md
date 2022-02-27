# Max's dotfiles

**Warning: very unstable, fork/use with care**

## Quick start

This repo is designed to be placed in `~/.config/`,
so you can just clone this repo with the following:<br>
(remember to do backup first)

```bash
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

If you are having a clean install (say WSL), please:
1. Get Git working (to a bare minimum, at least)
2. Clone this repo
3. Work on installing and setting up other apps

## Features

* Numerous aliases - see `./fish/config.fish` and `./git/config`
* Bookmarks through `fzf` - call with `m`
  * Bookmarks file in `~/.cd_bookmarks`
* Powerful setup for Tmux and Neovim
  * Various powerful and ergonomic plugins for Neovim
  * Vim-like key remaps for Tmux - see `./tmux/.tmux.conf`
  * Minimalist UI
* Minimal setup
  * Set Fish as default shell
  * Sync Neovim's plugins
  * Log in to GitHub CLI

## Program list

This is listed in the order of installation.
Those surrounded in brackets are found to be installed already in Ubuntu 20.04 LTS.
Appended data starting with `ppa:` is the PPA for Ubuntu.
If installed already and still have `ppa:` - they need upgrading with the PPA.

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
