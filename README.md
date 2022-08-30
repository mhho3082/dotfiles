# Max's dotfiles

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need first.

I currently use Manjaro with Xfce,
and have only tested this config on my own machine.
If you find any bugs, feel free to file an issue
(but I cannot promise a response).

```fish
# Make sure git and fish are installed
git --version
fish --version

# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git ~/Documents/dotfiles/

# Copy/update ~/.config (backup first if needed)
cd ~/Documents/dotfiles/
./copy_to_config.fish
```

For various frequently used (and forgotten) commands and motions,
please see the folder `./tips/`.

## Features

- Setup and update with little overhead
- Efficient aliases and functions with auto-complete
- Neovim setup with IDE powers and simple controls
- Minimalist UI for both the command line and desktop

## App list

The apps that I usually use (some of which I install only when needed):

<details>
<summary> App List </summary>

- Casual usage
  - `mupdf`
  - `firefox`
  - `discord`
- Command line
  - `fish`
  - `yay`
  - `exa`
  - `xclip`
  - `fd`
  - `fzf`
  - `ripgrep`
- School/Work
  - `zotero-bin`
  - `libreoffice-fresh`
- Coding
  - `nvim`
  - `github-cli` (`gh` in shell)
  - C/C++
    - `base-devel`
    - `llvm`
  - Rust
    - `rustup`
  - Python
    - `pyenv`
  - JS/TS
    - `node`
    - `npm`
- Utilities
  - `rofi`
  - `fcitx5` + `rime-cantonese`
  - `redshift`
  - `timeshift` (system backup)
  - `backintime` (user files backup)
  - `xsane`
- Themes and fonts
  - `mojave-gtk-theme`
  - `vimix-cursors`
  - `ttf-fira-code`
  - `ttf-ms-fonts`

</details>

Some extensions that I auto-install in my browsers:

<details>
<summary> Browser extensions </summary>

- `Vimium`
- `HTTPS Everywhere`
- `uBlock origin`
- `Zotero`
- `Facebook container`
- `Rust Search Extension`

</details>

I also install and remove packages in Neovim through `mason.nvim`
with respect to the languages I am currently working with.

<details>
<summary> Some `mason` stuff </summary>

- Rust
  - `rust-analyser`
- Lua
  - `lua-language-server`
  - `stylua`
- C/C++
  - `clangd`
- Grammar (Markdown and LaTeX)
  - `ltex`

</details>

## Handy setup scripts

A safe sequence to bootstrap `yay` from a clean installation
(for Arch-based distros):

```bash
sudo pacman-mirrors --fasttrack
sudo pacman -Syu

sudo pacman --needed -S lib32-glibc glibc
sudo pacman --needed -S git base-devel yay

sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
yay -Syu --devel --timeupdate
```

Set fish as the default shell (from bash / zsh):

```bash
chsh -s `which fish`
```

Set up Neovim plugins for the first time:

```bash
# Initiate setup
nvim +PackerSync

# Wait for Treesitter to compile dozens of parsers
# (should be quick on locally installed Linux)
# Type `:qa!`, then press enter, to quit
# Then open neovim again to do whatever you want
```

Optimize SSD usage:

```bash
sudo systemctl enable fstrim.timer
```

Source and use the setup for Tmux:

```bash
echo "source-file ~/.config/tmux/.tmux.conf" > ~/.tmux.conf
```

Login to GitHub CLI:

```bash
gh auth login
```

Get the fastest download times with `pacman`
(for Arch-based distros):

```bash
sudo pacman-mirrors --fasttrack
```

Get colours with `pacman` and `yay`:

```bash
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
```

To set up Git and GitHub with a GPG key for commits, see
[this page by With Blue Ink](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html)
(GPG is usually installed already; install if not.)

To set up Cantonese input with Rime, see
[this page by Rime's makers](https://github.com/rime/rime-cantonese/wiki)

## Auxiliary scripts

Pipe to clipboard:

```bash
echo "Hello world" | xclip
```

Remove Windows-style EOLs from a file:

```bash
# https://stackoverflow.com/questions/11680815/removing-windows-newlines-on-linux-sed-vs-awk
sed -e 's/\r//g' file.txt # replace with file name
```

Use SSH with kitty:

```bash
kitty +kitten ssh 127.0.0.1 # replace with ssh address
```

Test for 256-colours for your terminal emulator:

```bash
# https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal

curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

Symlink some renamed programs back to usual, e.g., `fdfind` to `fd`:

```bash
# Bash / Zsh
ln -s $(which fdfind) ~/.local/bin/fd
```

```fish
# Fish
ln -s (which fdfind) ~/.local/bin/fd
```

## Credits

- Git alias derived from
  https://github.com/mathiasbynens/dotfiles
- Tmux status bar based off of
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `m` bookmark function inspired by
  https://dmitryfrank.com/articles/shell_shortcuts
