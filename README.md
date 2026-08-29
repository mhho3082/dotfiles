# Max's dotfiles

## Quick start

If you want to use my config, please fork this repo,
look through the code, and remove the parts you don't need first.

```bash
# Clone the repo
git clone https://github.com/mhho3082/dotfiles.git --depth=1
cd dotfiles

# Copy/update to ~/.config (backup first if needed)
./copy_to_config.sh
```

## Features

- Setup and update with little overhead
- Efficient aliases and functions with auto-complete
- Neovim setup with IDE powers and simple controls
- Minimalist UI for both the command line and desktop

## App list

Apps used regularly
(some installed only when needed);
refer to their respective documentation for installation details:

<details>
<summary> App List </summary>

- Desktop environment
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
- CLI and TUI
  - [`eza`](https://github.com/eza-community/eza)
  - [`fd`](https://github.com/sharkdp/fd)
  - [`bat`](https://github.com/sharkdp/bat)
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide)
  - [`fzf`](https://github.com/junegunn/fzf)
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
  - [`xsel`](https://github.com/kfish/xsel)
  - [`libqalculate`](https://github.com/Qalculate/libqalculate)
  - [`trash-cli`](https://github.com/andreafrancia/trash-cli)
- Coding
  - [`neovim`](https://neovim.io/)
  - [`github-cli`](https://cli.github.com/)
  - [`delta`](https://dandavison.github.io/delta/)
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

The browser extensions:

<details>
<summary> Browser extensions </summary>

- [`uBlock Origin`](https://github.com/gorhill/uBlock)
- [`Redirector`](https://github.com/einaregilsson/Redirector)
- [`HTTPS Everywhere`](https://www.eff.org/https-everywhere)
- [`Facebook Container`](https://addons.mozilla.org/en-US/firefox/addon/facebook-container/)
- [`Enhancer for YouTube`](https://www.mrfdev.com/enhancer-for-youtube)

Gruvbox theme for browsers is [`teatwig/gruvbox-firefox-themes`](https://github.com/teatwig/gruvbox-firefox-themes)

(You may want to also activate additional filter lists in `uBlock Origin`
for things such as Facebook or cookie banners;
please refer to their [wiki](https://github.com/gorhill/uBlock/wiki).)

</details>

LSP servers in Neovim with `mason.nvim`:

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

Before running any `curl | bash`-style install script (common in official install guides,
e.g. `curl https://example.com/install.sh | bash`),
inspect it first with `bat` (or `cat`):

```bash
curl https://example.com/install.sh | bat
# then, if it looks safe:
curl https://example.com/install.sh | bash
```

To install Arch Linux, see the guide by [`DenshiVideo`](https://www.youtube.com/watch?v=68z11VAYMS8).
A few notes:

- You may see `/dev/nvme0n1` instead of `/dev/sda` as your block device
  (see [`Ask Ubuntu`](https://askubuntu.com/a/932336), check with `lsblk`);
  just substitute it in your commands.
- Prefer a swap file over a swap partition for flexibility;
  see [ArchWiki](https://wiki.archlinux.org/title/Swap#Swap_file).

[`EndeavourOS`'s package list](https://github.com/endeavouros-team/EndeavourOS-packages-lists)
is a useful reference for core packages to install after Arch
(some packages listed are `EndeavourOS`-only).

To bootstrap `paru` from a clean Arch-based installation:

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

Set `bash` as the default shell:

```bash
chsh -s `which bash`
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
if `xbacklight` is not working, switch to `brightnessctl`.

For brightness issues (e.g. brightness dropping to minimum on plug/unplug), see
[Backlight on ArchWiki](https://wiki.archlinux.org/title/Backlight#Kernel_command-line_options).
Setting `acpi_backlight=native` in Grub config often helps;
see [Kernel parameters on ArchWiki](https://wiki.archlinux.org/title/Kernel_parameters).

To fix screen-tearing issues with Ryzen APUs, see
[Ryzen on ArchWiki](<https://wiki.archlinux.org/title/Ryzen#Screen-tearing_(APU)>).

After configuring Grub, run `grub-mkconfig` then `grub-install`.
See [Grub on ArchWiki](https://wiki.archlinux.org/title/GRUB#Configuration).
For an example of installing a theme, see
[the Breeze theme README](https://github.com/gustawho/grub2-theme-breeze#installation).

For Colemak-DH on a staggered keyboard (e.g. a laptop),
set the keymap to `colemak_dh_ortho`;
see [discussion on Reddit](https://www.reddit.com/r/Colemak/comments/wqcspl/colemak_dh_on_linux/).

To have GnuPG use the terminal instead of a pop-up for passwords,
see [this StackExchange answer on editing `~/.gnupg/gpg-agent.conf`](https://unix.stackexchange.com/a/724765).

To keep using your laptop after closing the lid (e.g. with an external monitor),
see [this StackExchange answer](https://unix.stackexchange.com/a/52645).

To show the `lightdm` greeter on multiple screens,
see [this Chaotic Experiments post](https://chaoticlab.io/posts/lightdm-extmonitor/),
for example the semi-dynamic script below:

<!-- Use :r!cat /etc/lightdm/display_setup.sh to copy to below -->

<details>
<summary> <code>/etc/lightdm/display_setup.sh</code> </summary>

```bash

#!/bin/sh
#
# keep every connected monitor mirrored for the whole lifetime of the LightDM greeter,
# react to hotplug/unplug, then get out of the way.
#
# Inspired by https://chaoticlab.io/posts/lightdm-extmonitor/ , but instead of
# running once and using a single output, it runs as a tiny background worker and
# clones *all* outputs: a common mode is used when the monitors share one,
# RandR scaling otherwise (LightDM's own mirroring breaks on mixed resolutions).
#
# Usage:
#   lightdm-mirror-displays start   # from display-setup-script (returns at once)
#   lightdm-mirror-displays stop    # from session-setup-script / greeter cleanup
#   lightdm-mirror-displays run     # the worker itself (foreground, for debugging)

set -u

PROG=lightdm-mirror-displays
RUNDIR=${MIRROR_RUNDIR:-/run/lightdm-mirror}
POLL=${MIRROR_POLL:-2}                        # seconds between RandR checks
GREETER_RE=${MIRROR_GREETER_RE:-greeter}      # pgrep -f pattern of the greeter
GREETER_GRACE=${MIRROR_GREETER_GRACE:-60}     # give the greeter this long to appear

XRANDR=$(command -v xrandr 2>/dev/null || echo "")

# one worker per X display (multi-seat friendly)
tag=$(printf '%s' "${DISPLAY:-nodisplay}" | tr -c 'A-Za-z0-9' '_')
PIDFILE="$RUNDIR/$PROG$tag.pid"

log() {
	logger -t "$PROG" -- "$*" 2>/dev/null || printf '%s: %s\n' "$PROG" "$*" >&2
}

# ---------------------------------------------------------------- RandR helpers

# "OUTPUT mode mode mode ..." for every connected output that reports modes
outputs_info() {
	$XRANDR -q 2>/dev/null | awk '
		/^[^[:space:]]/ {
			if ($2 == "connected") { out = $1; printf "%s%s", (n++ ? "\n" : ""), out }
			else                     out = ""
			next
		}
		/^[[:space:]]+[0-9]+x[0-9]+/ { if (out != "") printf " %s", $1 }
		END { if (n) printf "\n" }'
}

# outputs that are disconnected but still driving a CRTC (stale clones)
stale_outputs() {
	$XRANDR -q 2>/dev/null | awk '$2 == "disconnected" && $0 ~ /[0-9]+x[0-9]+\+-?[0-9]+\+-?[0-9]+/ { print $1 }'
}

primary_output() {
	$XRANDR -q 2>/dev/null | awk '$2 == "connected" && $3 == "primary" { print $1; exit }'
}

# cheap "state of the world" fingerprint: who is connected + current geometry
signature() {
	$XRANDR -q 2>/dev/null | awk '/ connected| disconnected/ {
		geo = "off"
		for (i = 3; i <= NF; i++)
			if ($i ~ /^[0-9]+x[0-9]+\+-?[0-9]+\+-?[0-9]+$/) geo = $i
		print $1, $2, geo
	}'
}

# largest mode supported by *every* connected output ("" if there is none)
common_mode() {
	awk '
		{
			n++; seen = " "
			for (i = 2; i <= NF; i++)
				if (index(seen, " " $i " ") == 0) { seen = seen $i " "; cnt[$i]++ }
		}
		END {
			best = ""; bestarea = 0
			for (m in cnt) if (cnt[m] == n) {
				split(m, d, "x"); a = (d[1] + 0) * (d[2] + 0)
				if (a > bestarea) { bestarea = a; best = m }
			}
			print best
		}'
}

# pick_mode <anchor_w> <anchor_h> ; stdin: one "OUTPUT mode mode ..." line
# -> mode whose aspect ratio is closest to the anchor (largest one wins ties)
pick_mode() {
	awk -v aw="$1" -v ah="$2" '{
		target = aw / ah; best = ""; bestd = 1e9; besta = 0
		for (i = 2; i <= NF; i++) {
			split($i, d, "x"); w = d[1] + 0; h = d[2] + 0
			if (w <= 0 || h <= 0) continue
			r = w / h; diff = (r > target ? r - target : target - r); a = w * h
			if (diff < bestd - 1e-6 || (diff < bestd + 1e-6 && a > besta)) {
				bestd = diff; besta = a; best = $i
			}
		}
		print best
	}'
}

# ------------------------------------------------------------------- the action

apply_mirror() {
	info=$(outputs_info)
	[ -n "$info" ] || return 0

	# clone anchor: keep whatever is already primary, do not re-assign it
	anchor=$(primary_output)
	if [ -z "$anchor" ] || ! printf '%s\n' "$info" | grep -q "^$anchor "; then
		anchor=$(printf '%s\n' "$info" | head -n 1 | cut -d ' ' -f 1)
	fi

	args=""
	for dead in $(stale_outputs); do
		args="$args --output $dead --off"
	done

	mode=$(printf '%s\n' "$info" | common_mode)

	if [ -n "$mode" ]; then
		# --- true hardware clone: identical mode everywhere -------------------
		args="$args --output $anchor --mode $mode --scale 1x1 --rotate normal --pos 0x0"
		for name in $(printf '%s\n' "$info" | cut -d ' ' -f 1); do
			[ "$name" = "$anchor" ] && continue
			args="$args --output $name --mode $mode --scale 1x1 --rotate normal --same-as $anchor"
		done
	else
		# --- no common mode: scale every panel onto the anchor's area ---------
		aline=$(printf '%s\n' "$info" | grep "^$anchor ")
		amode=$(printf '%s\n' "$aline" | cut -d ' ' -f 2)
		aw=${amode%%x*}; ah=${amode#*x}; ah=${ah%%[!0-9]*}
		args="$args --output $anchor --mode $amode --scale 1x1 --rotate normal --pos 0x0"
		while read -r line; do
			name=${line%% *}
			[ "$name" = "$anchor" ] && continue
			m=$(printf '%s\n' "$line" | pick_mode "$aw" "$ah")
			[ -n "$m" ] || continue
			mw=${m%%x*}; mh=${m#*x}; mh=${mh%%[!0-9]*}
			scale=$(awk -v aw="$aw" -v ah="$ah" -v mw="$mw" -v mh="$mh" \
				'BEGIN { printf "%.6fx%.6f", aw / mw, ah / mh }')
			args="$args --output $name --mode $m --scale $scale --rotate normal --same-as $anchor"
		done <<-EOF
		$info
		EOF
	fi

	log "applying: xrandr$args"
	# no output name or mode contains whitespace, so word splitting is safe here
	# shellcheck disable=SC2086
	$XRANDR $args 2>&1 | while read -r l; do log "xrandr: $l"; done
}

# ----------------------------------------------------------------- worker & co.

run() {
	[ -n "$XRANDR" ]      || { log "xrandr not found, nothing to do"; exit 0; }
	[ -n "${DISPLAY:-}" ] || { log "DISPLAY is not set, nothing to do"; exit 0; }

	mkdir -p "$RUNDIR" 2>/dev/null
	echo $$ > "$PIDFILE" 2>/dev/null
	trap 'rm -f "$PIDFILE"' EXIT
	trap 'log "signalled, releasing xrandr"; exit 0' TERM INT HUP

	log "worker started on DISPLAY=$DISPLAY (pid $$)"

	last=""; greeter_seen=0; waited=0
	while :; do
		# X server gone (display server restarted / seat removed) -> we are done
		if ! $XRANDR -q >/dev/null 2>&1; then
			log "cannot talk to X on $DISPLAY, exiting"
			break
		fi

		# hotplug, unplug, or somebody else changed the layout -> re-mirror.
		# Storing the *post*-apply signature also prevents retry loops when a
		# requested configuration cannot be realised.
		sig=$(signature)
		if [ "$sig" != "$last" ]; then
			apply_mirror
			last=$(signature)
		fi

		# watchdog: hand control over as soon as the greeter is gone
		if pgrep -f -- "$GREETER_RE" >/dev/null 2>&1; then
			greeter_seen=1
		elif [ "$greeter_seen" -eq 1 ]; then
			log "greeter exited (user logged in?), releasing xrandr"
			break
		else
			waited=$((waited + POLL))
			if [ "$waited" -ge "$GREETER_GRACE" ]; then
				log "no greeter after ${GREETER_GRACE}s (autologin?), exiting"
				break
			fi
		fi

		sleep "$POLL"
	done
}

start() {
	# must never block or fail: LightDM waits for display-setup-script
	[ -n "$XRANDR" ]      || exit 0
	[ -n "${DISPLAY:-}" ] || exit 0
	mkdir -p "$RUNDIR" 2>/dev/null
	stop                                   # drop a stale worker for this display
	if command -v setsid >/dev/null 2>&1; then
		setsid "$0" run < /dev/null > /dev/null 2>&1 &
	else
		"$0" run < /dev/null > /dev/null 2>&1 &
	fi
	exit 0
}

stop() {
	[ -f "$PIDFILE" ] || return 0
	pid=$(cat "$PIDFILE" 2>/dev/null)
	if [ -n "${pid:-}" ] && kill -0 "$pid" 2>/dev/null; then
		kill -TERM "$pid" 2>/dev/null
		i=0
		while kill -0 "$pid" 2>/dev/null && [ "$i" -lt 20 ]; do
			sleep 0.1 2>/dev/null || sleep 1
			i=$((i + 1))
		done
		kill -KILL "$pid" 2>/dev/null
	fi
	rm -f "$PIDFILE"
	return 0
}

case "${1:-start}" in
	start) start ;;
	stop)  stop; exit 0 ;;
	run)   run;  exit 0 ;;
	*)     printf 'usage: %s {start|stop|run}\n' "$PROG" >&2; exit 2 ;;
esac
```

</details>

Then, modify `/etc/lightdm/lightdm.conf`:

<details>
<summary> <code>/etc/lightdm/lightdm.conf</code> </summary>

```conf
[Seat:*]
# ...
display-setup-script=/etc/lightdm/display_setup.sh start
session-setup-script=/etc/lightdm/display_setup.sh stop
# ...
```

</details>

## Credits

- Git alias derived from
  https://github.com/mathiasbynens/dotfiles
- Tmux status bar based on
  https://www.reddit.com/r/unixporn/comments/5vke7s/osx_iterm2_tmux_vim/
- `i3wm` config based on `EndeavourOS`'s default config at
  https://github.com/endeavouros-team/endeavouros-i3wm-setup
