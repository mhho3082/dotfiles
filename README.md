# Max's dotfiles

**Warning: very unstable, fork/use with care**

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need;
I can't ensure that my configurations will fit your needs.

This repo is designed to be placed in `~/.config/`,
so to use it on your machine, just clone it:

```bash
# Do backup if needed
tar -cpzf "$HOME/config_backup.tar.gz" "$HOME/.config/"

# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git ~/.config/
```

If you are having a clean install (say WSL), please:
1. Get (some version of) Git working
2. Connect the machine to the internet
3. Clone this repo
4. Work on installing and setting up other apps

For various frequently used commands and motions,
please see the folder `./tips/`.

## Features

* Numerous aliases - see `./fish/config.fish` and `./git/config`
* Get around your `marks` with fuzzy find (alias `m`)
  * Bookmarks file in `~/.cd_bookmarks`
* Powerful setup for Tmux and Neovim
  * Various powerful and ergonomic plugins for Neovim
  * Vim-like key remaps for Tmux - see `./tmux/.tmux.conf`
  * Minimalist UI

## App list

This is listed in the order of installation.
Those surrounded in brackets are found to be installed already in Ubuntu 20.04 LTS.
Appended data starting with `ppa:` is the PPA for Ubuntu.
If it is installed already and still have `ppa:` - it needs upgrading with the PPA.

<details>
<summary> App List </summary>

- (`curl`)
- (`tmux`)
- (`htop`)
- (`git`) (`ppa:git-core/ppa`)
- (`gcc`)
- `unzip`
- `fish` (`ppa:fish-shell/release-3`)
- `exa` (`ppa:spvkgn/exa`)
- `fzf`
- `ripgrep`
- `fd` (on Debian/Ubuntu: `fd-find`)
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
- `yapf` (on Debian/Ubuntu: `yapf3`)

</details>

Also are the language servers installed in Neovim through `nvim-lsp-installer`:

<details>
<summary> Language servers </summary>

- `clangd` (C, C++)
- `jedi_language_server` (Python)
- `ltex` (Grammar checking)
- `sumneko_lua` (Lua)

</details>

## Notes

To set fish as the default shell (from bash / zsh):

```bash
chsh -s `which fish`
```

Login to GitHub CLI:
```bash
gh auth login
```

To set up Neovim plugins for the first time:

```bash
nvim +PackerSync

# Or, if you have the fish alias running
n +PackerSync
```

On Ubuntu/Debian, symlink `fdfind` to `fd`:
(Same for `yapf3` to `yapf`)

```bash
# Bash / Zsh
ln -s $(which fdfind) ~/.local/bin/fd
```

```fish
# Fish
ln -s (which fdfind) ~/.local/bin/fd
```

If with tmux version < 3.1 (check with `tmux -V`),
add a file `~/.tmux.conf`:

```tmux
# Use config in ~/.config/
source-file ~/.config/tmux/.tmux.conf
```

Pipe to Windows clipboard from WSL:
```bash
echo "Hello world" | clip.exe
```

Test for 256-colours for your terminal emulator:
```bash
# From https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal

curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
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
