# Max's dotfiles

## Quick start

If you want to use my config, I would advise you to fork this repo,
look through the code, and remove the parts you don't need first.

```bash
# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git --depth=1
cd dotfiles

# Copy/update to ~/.config (backup first if needed)
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
(please kindly refer to their respective documentation):

<details>
<summary> App List </summary>

- CLI and TUI
  - [`zsh`](https://zsh.sourceforge.io/)
  - [`paru`](https://github.com/Morganamilo/paru)
  - [`eza`](https://github.com/eza-community/eza)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`xsel`](https://github.com/kfish/xsel)
  - [`libqalculate`](https://github.com/Qalculate/libqalculate) (`qalc` in shell)
  - [`trash-cli`](https://github.com/andreafrancia/trash-cli)
  - [`htop`](https://htop.dev/)
  - [`bashmount`](https://github.com/jamielinux/bashmount)
  - [`bluetuith`](https://github.com/darkhz/bluetuith)
- Coding
  - [`nvim`](https://neovim.io/)
  - [`github-cli`](https://cli.github.com/) (`gh` in shell)
  - [`difftastic`](https://github.com/Wilfred/difftastic)
  - [`base-devel`](https://archlinux.org/groups/x86_64/base-devel/)
  - [`llvm`](https://llvm.org/) (for C/C++ [`clangd`](https://clangd.llvm.org/) in editors)
- Writing
  - [`fcitx5`](https://fcitx-im.org/wiki/Fcitx_5)
    - [`fcitx5-rime`](https://github.com/fcitx/fcitx5-rime) +
      [`rime-cantonese`](https://github.com/rime/rime-cantonese) (for Cantonese)
    - [`fcitx5-mozc`](https://github.com/google/mozc) (for Japanese)
  - [`libreoffice-fresh`](https://www.libreoffice.org/)
    - [LanguageTool extension](https://extensions.libreoffice.org/en/extensions/show/languagetool)
  - [`pandoc-bin`](https://pandoc.org/)
    - [`texlive`](https://tug.org/texlive/)
    - [`pandoc-crossref-bin`](https://github.com/lierdakil/pandoc-crossref)
    - [`mermaid-filter`](https://github.com/raghur/mermaid-filter)
  - [`zathura`](https://pwmt.org/projects/zathura/)
    - [`zathura-pdf-mupdf`](https://github.com/pwmt/zathura-pdf-mupdf)
    - [`zaread`](https://github.com/paoloap/zaread)
- Web surfing
  - [`firefox`](https://www.mozilla.org/en-US/firefox/)
  - [`chromium`](https://www.chromium.org/Home/)
  - [`discord`](https://discord.com/)
- Desktop environment setup
  - [`i3-wm`](https://i3wm.org/)
  - [`wezterm`](https://github.com/wez/wezterm)
  - [`betterlockscreen`](https://github.com/betterlockscreen/betterlockscreen)
  - [`feh`](https://feh.finalrewind.org/)
  - [`rofi`](https://github.com/davatorium/rofi)
  - [`polybar`](https://github.com/polybar/polybar)
  - [`brightnessctl`](https://github.com/Hummer12007/brightnessctl)
  - [`xidlehook`](https://gitlab.com/jD91mZM2/xidlehook)
  - [`redshift`](http://jonls.dk/redshift/)
  - [`networkmanager-dispatcher-ntpd`](https://man.archlinux.org/man/NetworkManager-dispatcher.8.en)
- Utilities
  - [`flameshot`](https://flameshot.org/)
  - [`xsane`](http://www.sane-project.org/)
  - [`ventoy`](https://www.ventoy.net)
- Fonts
  - [`ttf-jetbrains-mono-nerd`](https://www.jetbrains.com/lp/mono/)
  - [`noto-fonts`](https://fonts.google.com/noto)
  - [`noto-fonts-emoji`](https://fonts.google.com/noto/specimen/Noto+Emoji)
  - [`ttf-ms-fonts`](https://wiki.archlinux.org/title/Microsoft_fonts)
- Themes
  - [`nwg-look`](https://github.com/nwg-piotr/nwg-look)
  - [`gruvbox-material-gtk-theme-git`](https://github.com/TheGreatMcPain/gruvbox-material-gtk)
  - [`qogir-icon-theme`](https://github.com/vinceliuice/Qogir-icon-theme)
  - [`fcitx5-gruvbox-dark-theme-git`](https://github.com/pu-007/fcitx5-gruvbox-dark-theme)
  - [`grub-theme-vimix`](https://github.com/Se7endAY/grub2-theme-vimix)
  - [`lightdm-webkit-theme-litarvan`](https://github.com/Litarvan/lightdm-webkit-theme-litarvan)

</details>

Some extensions that I install in my browsers:

<details>
<summary> Browser extensions </summary>

- [`Vimium`](https://github.com/philc/vimium)
- [`uBlock Origin`](https://github.com/gorhill/uBlock)
- [`Dark Background and Light Text`](https://github.com/m-khvoinitsky/dark-background-light-text-extension)
- [`Redirector`](https://github.com/einaregilsson/Redirector)
- [`Tab Session Manager`](https://github.com/sienori/Tab-Session-Manager)
- `HTTPS Everywhere`
- `Facebook Container`

Gruvbox theme for browsers used is [`teatwig/gruvbox-firefox-themes`](https://github.com/teatwig/gruvbox-firefox-themes)

(You may want to also activate additional filter lists in `uBlock Origin`
for things such as Facebook or cookie banners;
please refer to their [wiki](https://github.com/gorhill/uBlock/wiki).)

</details>

I also install some LSP servers in Neovim with `mason.nvim`
with respect to the languages I am currently working with.
Some other LSP servers need to also be ported using `efm`;
they are marked below.

<details>
<summary> Some LSP servers </summary>

- General
  - `efm` (needs `go` installed)
- JS/TS
  - `tsserver`
  - `prettierd` (through `efm`)
- CSS
  - `css-lsp`
- Lua
  - `lua-language-server`
  - `stylua` (through `efm`)
- C/C++
  - `clangd`
- Markdown
  - `ltex`
  - `marksman`
- Bash
  - `bash-language-server`
  - `beautysh`

</details>

## Handy setup scripts

A safe sequence to bootstrap `paru` from a clean installation
(for Arch-based distros):

```bash
# Add colour to pacman CLI
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# Get fast mirrors
sudo reflector --country hk,jp,sg,kr,tw,gb,us --age 1 --protocol https --sort rate --fastest 10 --verbose --save /etc/pacman.d/mirrorlist

# Update system
sudo pacman -Syu

# Install dependencies
sudo pacman --needed base-devel git

# Install paru by cloning locally
git clone https://aur.archlinux.org/paru.git --depth=1
cd paru
makepkg -si
```

Set `zsh` as the default shell (from bash):

```bash
chsh -s `which zsh`
```

Optimize SSD usage:

```bash
sudo systemctl enable fstrim.timer
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
[the `rime-cantonese` wiki page by Rime's makers](https://github.com/rime/rime-cantonese/wiki).

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

To have GnuPG use the terminal instead of a pop-up window for asking passwords,
see [this Stack Exchange answer on editing `~/.gnupg/gpg-agent.conf`](https://unix.stackexchange.com/a/724765).

To show `lightdm` greeter on multiple screens,
see [this Chaotic Experiments post](https://chaoticlab.io/posts/lightdm-extmonitor/);
my (semi-dynamic) `/etc/lightdm/display_setup.sh` is as below:

<!-- Use :r!cat /etc/lightdm/display_setup.sh to copy to below -->

<details>
<summary> My <code>/etc/lightdm/display_setup.sh</code> script </summary>

```bash
#!/bin/sh

# Primary display is always known, typically something like eDP for laptops;
# Please check xrandr to be sure
PRIMARY_MONITOR="eDP"

# Get all connected monitors except the primary one
OTHER_MONITORS=$(xrandr --query | grep " connected" | grep -v "$PRIMARY_MONITOR" | cut -d" " -f1)

# Enable the primary monitor first
xrandr --output "$PRIMARY_MONITOR" --auto --primary

# Loop through all other connected monitors and mirror them to the primary monitor
for MONITOR in $OTHER_MONITORS; do
    xrandr --output "$MONITOR" --auto --same-as "$PRIMARY_MONITOR"
done
```

</details>

## Credits

- Git alias derived from
  https://github.com/mathiasbynens/dotfiles
- Tmux status bar based off of
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `m` bookmark function inspired by
  https://dmitryfrank.com/articles/shell_shortcuts
- `i3wm` config based on `EndeavourOS`'s default config at
  https://github.com/endeavouros-team/endeavouros-i3wm-setup
- Caps-lock to escape remap + escape to backtick remap derived from
  https://unix.stackexchange.com/questions/692851/
