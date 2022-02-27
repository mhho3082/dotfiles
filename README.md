# Max's dotfiles

**Warning: very unstable, fork/use with care**

## Quick start

This repo is designed to be placed in `~/.config/`,
so you can just clone this repo with the following:<br>
(remember to do backup first if needed)

```bash
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

## Program list

This is listed in the order of installation.
Those surrounded in brackets are found to be installed already in Ubuntu 20.04 LTS.
Appended data is the PPA for Ubuntu.

<details>
<summary><u>App List</u></summary>

- (`tmux`)
- (`htop`)
- `git` (`ppa:git-core/ppa`)
- `unzip`
- `fish` (`ppa:fish-shell/release-3`)
- `exa` (`ppa:spvkgn/exa`)
- `fzf`
- `ripgrep`
- `fd-find`
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
- `neovim` module (`sudo npm install -g neovim`)
- `clang`
- `clang-format`
- `llvm`
- `tldr` (`sudo npm install -g tldr`)

</details>

## Notes

To sync Neovim plugins (from the terminal):

```bash
n +PackerSync
```

(Weird) names for `fd`:
- Ubuntu/Debian: `fdfind` (Used throughout the config)
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
