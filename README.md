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
(some of which I install only when needed),
which may take additional setup to install
(please refer to their respective documentation):

<details>
<summary> App List </summary>

- Casual usage
  - [`firefox`](https://www.mozilla.org/en-US/firefox/)
  - [`chromium`](https://www.chromium.org/Home/)
  - [`vimb`](https://fanglingsu.github.io/vimb/)
    - [`wyebadblock-git`](https://github.com/jun7/wyebadblock)
      (Needs linking to `vimb`, see GitHub README)
  - [`zathura`](https://pwmt.org/projects/zathura/)
    - [`zathura-pdf-mupdf`](https://github.com/pwmt/zathura-pdf-mupdf)
  - [`discord`](https://discord.com/)
- Command line
  - [`zsh`](https://zsh.sourceforge.io/)
  - [`yay`](https://github.com/Jguer/yay)
  - [`exa`](https://github.com/ogham/exa)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`sd`](https://github.com/chmln/sd)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`vifm`](https://github.com/vifm/vifm)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`xsel`](https://github.com/kfish/xsel)
  - [`wezterm`](https://github.com/wez/wezterm)
  - [`mpv`](https://github.com/mpv-player/mpv)
    - [`mpv-uosc-git`](https://github.com/tomasklaen/uosc)
      - [`mpv-thumbfast-git`](https://github.com/po5/thumbfast)
    - [`pyradio`](https://github.com/coderholic/pyradio)
    - [`yt-dlp`](https://github.com/yt-dlp/yt-dlp)
- [`libqalculate`](https://github.com/Qalculate/libqalculate) (`qalc` in shell)
- School
  - [`libreoffice-fresh`](https://www.libreoffice.org/)
    - [LanguageTool extension](https://extensions.libreoffice.org/en/extensions/show/languagetool)
  - [`zotero-bin`](https://www.zotero.org/)
- Coding
  - [`nvim`](https://neovim.io/)
  - [`just`](https://github.com/casey/just)
  - [`github-cli`](https://cli.github.com/) (`gh` in shell)
  - [`difftastic`](https://github.com/Wilfred/difftastic)
  - [`base-devel`](https://archlinux.org/groups/x86_64/base-devel/)
  - For C/C++
    - [`llvm`](https://llvm.org/) (for [`clangd`](https://clangd.llvm.org/) in editors)
    - [`clang-format`](https://clang.llvm.org/docs/ClangFormat.html)
  - For Rust
    - [`rustup`](https://rustup.rs/)
    - [`cargo-edit`](https://github.com/killercup/cargo-edit)
  - For JavaScript
    - [`node`](https://nodejs.org/en)
    - [`yarn`](https://yarnpkg.com/)
- Desktop environment setup
  - [`i3-wm`](https://i3wm.org/)
  - [`betterlockscreen`](https://github.com/betterlockscreen/betterlockscreen)
  - [`feh`](https://feh.finalrewind.org/)
  - [`rofi`](https://github.com/davatorium/rofi)
  - [`polybar`](https://github.com/polybar/polybar)
  - [`brightnessctl`](https://github.com/Hummer12007/brightnessctl)
  - [`xidlehook`](https://gitlab.com/jD91mZM2/xidlehook)
  - [`redshift`](http://jonls.dk/redshift/)
  - [`networkmanager-dispatcher-ntpd`](https://man.archlinux.org/man/NetworkManager-dispatcher.8.en)
- Utilities
  - [`htop`](https://htop.dev/)
  - [`xsane`](http://www.sane-project.org/)
  - [`pinta`](https://www.pinta-project.com/) for casual image editing
    (or [`krita`](https://krita.org/) for serious drawing)
  - [`fcitx5`](https://fcitx-im.org/wiki/Fcitx_5)
    - [`fcitx5-rime`](https://github.com/fcitx/fcitx5-rime) +
      [`rime-cantonese`](https://github.com/rime/rime-cantonese) (Cantonese)
    - [`fcitx5-mozc`](https://github.com/google/mozc) (Japanese)
  - [`qemu-full`](https://www.qemu.org/) + [`virt-manager`](https://virt-manager.org/)
  - [`pandoc`](https://pandoc.org/) + [`texlive-most`](https://tug.org/texlive/)
  - [`flameshot`](https://flameshot.org/)
- Fonts
  - [`nerd-fonts-jetbrains-mono`](https://www.jetbrains.com/lp/mono/)
  - [`nerd-fonts-fira-code`](https://github.com/tonsky/FiraCode)
  - [`ttf-ms-fonts`](https://wiki.archlinux.org/title/Microsoft_fonts)
- Themes
  - [`gruvbox-material-gtk-theme-git`](https://github.com/TheGreatMcPain/gruvbox-material-gtk)
  - [`eos-qogir-icons`](https://github.com/vinceliuice/Qogir-icon-theme)
  - [`fcitx5-gruvbox-dark-theme-git`](https://github.com/pu-007/fcitx5-gruvbox-dark-theme)
  - [`grub-theme-vimix`](https://github.com/Se7endAY/grub2-theme-vimix)
  - [`lightdm-webkit-theme-litarvan`](https://github.com/Litarvan/lightdm-webkit-theme-litarvan)

</details>

Some extensions that I install in my browsers:

<details>
<summary> Browser extensions </summary>

- `Vimium`
- `HTTPS Everywhere`
- `uBlock Origin`
- `Dark Reader`
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

- HTML
  - `emmet-ls`
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

Set up `betterlockscreen`:

```bash
# This would update the cached image
betterlockscreen -u "/path/to/img.jpg"
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
- Caps-lock to escape remap + escape to backtick remap derived from
  https://unix.stackexchange.com/questions/692851/
