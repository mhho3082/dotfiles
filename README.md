# Max's dotfiles

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need.

I currently use Manjaro with Xfce,
and have only tested this config on my own machine;
if you find any bugs, feel free to file an issue
(but I cannot promise a response).

```fish
# Install git and fish beforehand
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

- Quick setup
- Efficient aliases and functions with auto-complete
- Powerful, nearly stand-alone Neovim configuration
- Minimalist UI

## App list

<details>
<summary> App List </summary>

- Coding
  - `fish`
  - `nvim`
  - `github-cli` (`gh` on the command line)
  - `python`
  - `nodejs`
- Command line
  - `yay`
  - `exa`
  - `xclip`
  - `fd`
  - `fzf`
  - `ripgrep`
  - `tmux`
  - `ranger`
- Linters
  - `prettierd` (JS and more)
  - `clang-format`
  - `yapf` (Python)
- Usual stuff
  - `mupdf`
  - `firefox`
  - `chromium`
  - `libreoffice-fresh`
  - `discord`
  - `signal-desktop`
- Utilities
  - `rofi`
  - `kazam`
  - `fcitx5` (with `rime` plugin)
  - `redshift`
  - `timeshift` (system backup)
  - `backintime` (user files backup)
  - `imagewriter`
  - `xsane`
- School
  - `zotero-bin`
  - `teams-natifier`
  - `zoom`
  - `simplenote-electron-bin`
  - installed only when needed:
    - `audacity`
    - `insomnia`
    - `logisim`
    - `qtspim`
- Theme and fonts
  - `whitesur-gtk-theme`
  - `tela-icon-theme`
  - `nordzy-cursors`
  - `ttf-fira-code`
  - `noto-fonts`
  - `ttf-ms-fonts`
  - `ttf-inconsolata`

</details>

The extensions I usually install to my browsers:

<details>
<summary> Browser extensions </summary>

- `Vimium`
- `HTTPS Everywhere`
- `uBlock origin`
- `Zotero`
- `Facebook container`

</details>

Some language servers I have installed in Neovim through `nvim-lsp-installer`:

<details>
<summary> Language servers </summary>

- `clangd` (C, C++)
- `jedi_language_server` (Python)
- `ltex` (Grammar checking)
- `sumneko_lua` (Lua)
- `bashls` (Bash)
- `tsserver` (JavaScript and TypeScript)
- `volar` (Vue)

</details>

## Handy setup scripts

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
# type `:qa!` to quit
# then open neovim again to do whatever you want
```

Login to GitHub CLI:

```bash
gh auth login
```

To set up Git and GitHub with a GPG key for commits, see
[this page by With Blue Ink](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html)
(GPG is usually installed already; install if not.)

To set up Cantonese input with Rime, see
[this page by Rime's makers](https://github.com/rime/rime-cantonese/wiki)

If you are with tmux version < 3.1 (check with `tmux -V`)
(more likely if using LTS distros or WSL):

```bash
echo "source-file ~/.config/tmux/.tmux.conf" > ~/.tmux.conf
```

## Auxiliary scripts

Pipe to clipboard:

```bash
echo "Hello world" | xclip
```

Remove Windows-style EOLs from a file:

```bash
# https://stackoverflow.com/questions/11680815/removing-windows-newlines-on-linux-sed-vs-awk
sed -e 's/\r//g' file.txt
```

Use SSH with kitty:

```bash
kitty +kitten ssh 127.0.0.1 # Replace with ssh address
```

Test for 256-colours for your terminal emulator:

```bash
# From https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal

curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

Symlink some renamed programs back to usual, e.g., `fdfind` to `fd`
(more common on Debian-based distros):

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
