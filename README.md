# Max's dotfiles

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need first.

```bash
# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git ~/Documents/dotfiles/
cd ~/Documents/dotfiles/

# Copy/update to ~/.config (backup first if needed)
chmod +x ./copy_to_config.sh
./copy_to_config.sh
```

For various frequently used (and forgotten) commands and motions,
please see the folder [`./tips/`](https://github.com/mhho3082/dotfiles/tree/main/tips).

## Features

- Setup and update with little overhead
- Efficient aliases and functions with auto-complete
- Neovim setup with IDE powers and simple controls
- Minimalist UI for both the command line and desktop

## App list

The apps that I usually use
(some of which I install only when needed):

<details>
<summary> App List </summary>

- Casual usage
  - `firefox`
  - `chromium`
  - `zathura`
  - `discord`
- Command line
  - `zsh`
  - `yay`
  - `exa`
  - `fd`
  - `fzf`
  - `ripgrep`
  - `xsel`
  - `wezterm`
- School
  - `libreoffice-fresh`
  - `zotero-bin`
- Coding
  - `nvim`
  - `just`
  - `github-cli` (`gh` in shell)
  - `difftastic`
  - `base-devel`
  - For C/C++
    - `llvm` (for `clangd` in editors)
    - `clang-format`
  - For Rust
    - `rustup`
    - `cargo-edit`
  - For JavaScript
    - `node`
    - `yarn`
- Desktop environment setup
  - `i3-gaps`
  - `rofi`
  - `polybar`
  - `brightnessctl`
  - `xidlehook`
  - `redshift`
- Utilities
  - `htop`
  - `xsane`
  - `fcitx5`
    - `fcitx5-rime` + `rime-cantonese` (Cantonese)
    - `fcitx5-mozc` (Japanese)
  - `qemu-full` + `virt-manager`
- Fonts
  - `nerd-fonts-jetbrains-mono`
  - `nerd-fonts-fira-code`
  - `ttf-ms-fonts`
- Themes
  - `gruvbox-material-gtk-theme-git`
  - `eos-qogir-icons`
  - `fcitx5-gruvbox-dark-theme-git`

</details>

Some extensions that I install in my browsers:

<details>
<summary> Browser extensions </summary>

- `Vimium`
- `HTTPS Everywhere`
- `uBlock Origin`
- `Zotero Connector`
- `Facebook Container`
- `Rust Search Extension`

Gruvbox theme is installed from
https://github.com/teatwig/gruvbox-firefox-themes

(You may want to also activate additional filter lists in `uBlock Origin`
for things such as Facebook or cookie banners;
please refer to their [wiki](https://github.com/gorhill/uBlock/wiki).)

</details>

I also install some LSP servers in Neovim with `mason.nvim`
with respect to the languages I am currently working with.
Some other LSP servers need to also be ported into Neovim
with `null-ls.nvim`; they are marked below.

<details>
<summary> Some LSP servers </summary>

- Rust
  - `rust-analyser`
- Lua
  - `lua-language-server`
  - `stylua` (needs `null-ls`)
- C/C++
  - `clangd`
- Markdown
  - `ltex`
  - `prettierd` (needs `null-ls`)
- Bash
  - `bash-language-server`
  - `shellharden` (needs `null-ls`)
- Fish (these come with the `fish` shell)
  - `fish` (needs `null-ls`)
  - `fish-indent` (needs `null-ls`)

</details>

## Handy setup scripts

A safe sequence to bootstrap `yay` from a clean installation
(for Arch-based distros):

```bash
# Add colour to pacman & yay CLIs
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# Get fast mirrors
sudo pacman-mirrors --fasttrack

# Update system
sudo pacman -Syu

# Install dependencies & yay
sudo pacman --needed -S lib32-glibc glibc
sudo pacman --needed -S git base-devel yay

# Init and launch yay for the first time
yay -Syu --devel --timeupdate
```

Set zsh as the default shell (from bash):

```bash
chsh -s `which zsh`
echo "source $HOME/.config/.zshrc" > ~/.zshrc
```

Or. set fish as the default shell (from bash / zsh):

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

To set up a GPG key for Git and GitHub usage, see
[How to Sign Git Commits by With Blue Ink](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html).

To set up Cantonese input with Rime, see
[this wiki page by Rime's makers](https://github.com/rime/rime-cantonese/wiki).

This config uses `brightnessctl` by default;
if you find `xbacklight` not working, you are advised to switch to `brightnesctl`.

For fixing brightness issues
(esp. brightness drops to minimum when (un)plugging), see
[Backlight on ArchWiki](https://wiki.archlinux.org/title/Backlight#Kernel_command-line_options).
You may want to set `acpi_backlight=native` in Grub config, for which see
[Kernel parameters on ArchWiki](https://wiki.archlinux.org/title/Kernel_parameters).

To fix screen-tearing issues with Ryzen APUs, see
[Ryzen on ArchWiki](<https://wiki.archlinux.org/title/Ryzen#Screen-tearing_(APU)>).

After you configure Grub, remember to `grub-mkconfig`, then `grub-install`.
See [Grub on ArchWiki](https://wiki.archlinux.org/title/GRUB#Configuration).
A nice example of installing a theme can be seen
[in the Breeze theme README](https://github.com/gustawho/grub2-theme-breeze#installation).

## Credits

- Git alias derived from
  https://github.com/mathiasbynens/dotfiles
- Tmux status bar based off of
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `m` bookmark function inspired by
  https://dmitryfrank.com/articles/shell_shortcuts
- `i3wm` config copied from `EndeavourOS`'s default config at
  https://github.com/endeavouros-team/endeavouros-i3wm-setup
