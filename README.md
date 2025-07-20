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
  - [`eza`](https://github.com/eza-community/eza)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`xsel`](https://github.com/kfish/xsel)
  - [`libqalculate`](https://github.com/Qalculate/libqalculate)
  - [`trash-cli`](https://github.com/andreafrancia/trash-cli)
- Coding
  - [`neovim`](https://neovim.io/)
  - [`github-cli`](https://cli.github.com/)
  - [`difftastic`](https://github.com/Wilfred/difftastic)
  - [`base-devel`](https://archlinux.org/groups/x86_64/base-devel/)
  - [`llvm`](https://llvm.org/) (for C/C++ [`clangd`](https://clangd.llvm.org/) in editors)
- Version managers
  - [`nvm`](https://github.com/nvm-sh/nvm)
  - [`pyenv`](https://github.com/pyenv/pyenv) and [`pyenv-virtualenv`](https://github.com/pyenv/pyenv-virtualenv)
  - [`rustup`](https://rustup.rs/)
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
  - [`mousepad`](https://github.com/codebrainz/mousepad)
- Web surfing
  - [`firefox`](https://www.mozilla.org/en-US/firefox/)
  - [`chromium`](https://www.chromium.org/Home/)
  - [`discord`](https://discord.com/)
- Desktop environment setup
  - [`i3-wm`](https://i3wm.org/)
  - [`paru`](https://github.com/Morganamilo/paru)
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
  - [`htop`](https://htop.dev/)
  - [`flameshot`](https://flameshot.org/)
  - [`xsane`](http://www.sane-project.org/)
  - [`bashmount`](https://github.com/jamielinux/bashmount)
  - [`bluetuith`](https://github.com/darkhz/bluetuith)
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
- [`HTTPS Everywhere`](https://www.eff.org/https-everywhere)
- [`Facebook Container`](https://addons.mozilla.org/en-US/firefox/addon/facebook-container/)

Gruvbox theme for browsers is [`teatwig/gruvbox-firefox-themes`](https://github.com/teatwig/gruvbox-firefox-themes)

(You may want to also activate additional filter lists in `uBlock Origin`
for things such as Facebook or cookie banners;
please refer to their [wiki](https://github.com/gorhill/uBlock/wiki).)

</details>

I also install some LSP servers in Neovim with `mason.nvim`
with respect to the languages I am currently working with.

<details>
<summary> Some LSP servers </summary>

- JS/TS
  - `tsserver`
  - `prettierd`
- CSS
  - `css-lsp`
- Lua
  - `lua-language-server`
  - `stylua`
- C/C++
  - `clangd`
- Markdown
  - `harper_ls`
  - `marksman`
- Bash
  - `bash-language-server`
  - `beautysh`

</details>

## Handy setup guides

To install Arch Linux, please see the very helpful guide by [`DenshiVideo`](https://www.youtube.com/watch?v=68z11VAYMS8).
Interesting things to note:

- You may see something like `/dev/nvme0n1` instead of `/dev/sda` as your block device
  (see [`Ask Ubuntu`](https://askubuntu.com/a/932336), and check with `lsblk`);
  it is fine, just use that instead of `sda` in your commands.
- Different to the guide, you are often advised to use a swap file instead of a partition
  (for flexibility and future modifications), with a guide on [ArchWiki](https://wiki.archlinux.org/title/Swap#Swap_file).

You could refer to [`EndeavourOS`'s package list](https://github.com/endeavouros-team/EndeavourOS-packages-lists)
for some ideas for core packages to install after installing Arch
(note that some packages listed are `EndeavourOS`-only).

A safe sequence to bootstrap `paru` from a clean installation
(for Arch-based distros):

```bash
# Add colour to pacman CLI
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# Get fast mirrors
sudo reflector --country hk,jp,sg,kr,tw,gb,us --age 5 --protocol https --sort rate --fastest 10 --verbose --save /etc/pacman.d/mirrorlist

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

Enable timers:

```bash
# Optimize SSD usage by removing unused filesystem blocks weekly
sudo systemctl enable --now fstrim.timer

# Clean pacman cache weekly (paru's still need to `paru -Sc`, though)
sudo systemctl enable --now paccache.timer
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

To remove the annoying "Clicking shift turns into ASCII-only mode" with Rime, adjust as below:

<details>
<summary> <code>~/.local/share/fcitx5/rime/default.custom.yaml</code> </summary>

```yaml
patch:
  schema_list:
    # ...
  ascii_composer:
    good_old_caps_lock: true
    switch_key:
      # Shift_L: inline_ascii
      # Shift_R: commit_text
      Shift_L: noop
      Shift_R: noop
      Control_L: noop
      Control_R: noop
      Caps_Lock: clear
      Eisu_toggle: clear
```

</details>

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
see [this StackExchange answer on editing `~/.gnupg/gpg-agent.conf`](https://unix.stackexchange.com/a/724765).

If you want to keep using your laptop after closing the lid
(eg with another monitor),
see [this StackExchange answer](https://unix.stackexchange.com/a/52645).

To show `lightdm` greeter on multiple screens,
see [this Chaotic Experiments post](https://chaoticlab.io/posts/lightdm-extmonitor/),
for example below semi-dynamic script:

<!-- Use :r!cat /etc/lightdm/display_setup.sh to copy to below -->

<details>
<summary> <code>/etc/lightdm/display_setup.sh</code> </summary>

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
- Tmux status bar based on
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `i3wm` config based on `EndeavourOS`'s default config at
  https://github.com/endeavouros-team/endeavouros-i3wm-setup
