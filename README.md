# Max's dotfiles

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need;
I can't ensure that my configurations will fit your needs.

This repo is designed to be utilized with `~/.config/`,
so feel free to clone this repo and copy files over there:

```bash
# Clone the repo, e.g., to dotfiles/
git clone https://github.com/mhho3082/dotfiles.git ~/Documents/dotfiles/

# Copy / update all files non-destructuvely over to ~/.config
# Will not remove already existing files, but will update them if duplicate
# (backup ~/.config if needed)
cd dotfiles
./copy_to_config.fish

# If fish isn't installed, but you want to copy everything over
# (warning: this is destructive)
cp -r ~/Documents/dotfiles/ ~/.config/

# If fish isn't installed, but you want to update particular files
# e.g., for git/config
cp ~/Documents/dotfiles/git/config ~/.config/git/config
```

If you are having a clean install, you may:

1. Get Git working
2. Connect the machine to the internet
3. Clone this repo
4. Copy files to` ~/.config`
5. Work on installing and setting up other apps
6. Set up GPG key and link it to Git and GitHub

For various frequently used commands and motions,
please see the folder `./tips/`.

## Features

- Efficient aliases and functions
  - see e.g. `./fish/config.fish` and `./git/config`
- Get around your `marks` with fuzzy find (alias `m`)
  - Bookmarks file is `~/.cd_bookmarks`
- Powerful setup for Tmux and Neovim
  - Various powerful and ergonomic plugins for Neovim
  - Vim-like key remaps for Tmux - see `./tmux/.tmux.conf`
  - Minimalist UI

## App list

This is a list of applications I use, many of which daily, others when needed.
I currently use Manjaro and have thrown Windows out of my window (pun intended),
so many things I would have to install myself is already there.
You would find some program with configurations in this repo,
but not listed in the list below (say `tmux`).
If you are stuck using WSL, then your mileage with this repo may vary.

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
  - `ranger`
- Linters
  - `clang-format`
  - `yapf` (Python)
  - `prettierd` (JS and more)
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

Also are some language servers I usually install in Neovim through `nvim-lsp-installer`:

<details>
<summary> Language servers </summary>

- `clangd` (C, C++)
- `jedi_language_server` (Python)
- `ltex` (Grammar checking)
- `sumneko_lua` (Lua)
- `bashls` (Bash)
- `tsserver` (JavaScript)

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

To set up Git and GitHub with a GPG key for commits, see
[this page by With Blue Ink](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html).
(GPG is usually installed already; install if not.)

To set up Neovim plugins for the first time:

```bash
nvim +PackerSync

# Then wait for Treesitter to compile dozens of parsers
# (should be quick on locally installed Linux),
# `:qa!` to quit,
# then re-open to do whatever you want
```

To set up Cantonese input with Rime, see
[this page by the makers](https://github.com/rime/rime-cantonese/wiki).

Remove Windows EOLs from some file
(dos2unix may not be pre-installed):

```bash
# https://stackoverflow.com/questions/11680815/removing-windows-newlines-on-linux-sed-vs-awk
sed -e 's/\r//g' file
```

Use SSH with kitty:

```bash
kitty +kitten ssh 127.0.0.1 # Replace with ssh address
```

Symlink some renamed programs back to usual, e.g., `fdfind` to `fd`
(common on Debian-based distros, usually not needed for Arch-based distros):

```bash
# Bash / Zsh
ln -s $(which fdfind) ~/.local/bin/fd
```

```fish
# Fish
ln -s (which fdfind) ~/.local/bin/fd
```

If you are with tmux version < 3.1 (check with `tmux -V`)
(common for LTS distros, WSL, or older machines),
add a file `~/.tmux.conf` with the following text to link to` ~/.config`:

```tmux
# Use config in ~/.config/
source-file ~/.config/tmux/.tmux.conf
```

Pipe to clipboard:

```bash
echo "Hello world" | xclip
```

Test for 256-colours for your terminal emulator:

```bash
# From https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal

curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

If you want to remove the local Windows paths from the WSL paths (not advised),
add a file with `sudo nano /etc/wsl.conf`:

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
