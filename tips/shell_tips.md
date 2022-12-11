# Shell tips

## One-liners

Find the largest files/directories in a directory:
(Helpful when clearing out disk space)

```bash
# Change `~` to the desired directory, or remove for current directory
du ~ -h -d 1 | sort -hr
```

Remove a package completely and safely with `pacman`:
(From [Reddit](https://www.reddit.com/r/archlinux/comments/ki9hmm/how_to_properly_removeuninstall_packagesapps_with/))

```bash
# Replace "package" with package name (fish has auto-complete for this)
# You can replace `pacman` with `yay` here
pacman -Runs package
```

Pipe from/to clipboard with `xclip`:

```bash
# Pipe into clipboard
echo "Hello world" | xsel -ib

# Or, append into clipboard
echo "Hello world" | xsel -ab

# Pipe from clipboard
xsel -ob

# Or, just pipe from/to a file...
xsel -b < in.txt  # Copy
xsel -b > out.txt # Paste
```

Remove Windows-style EOLs from a file:
(From [Stack Overflow](https://stackoverflow.com/questions/11680815/removing-windows-newlines-on-linux-sed-vs-awk))

```bash
sed -e 's/\r//g' file.txt # replace with file name
```

Use SSH with kitty (if normal SSH does not work for some reason):

```bash
kitty +kitten ssh 127.0.0.1 # replace with ssh address
```

Test for 256-colours for your terminal emulator:
(From [Ask Ubuntu](https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal))

```bash
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

Symlink to "rename" programs, e.g., `fdfind` to `fd`:

```bash
# From Bash / Zsh
ln -s $(which fdfind) ~/.local/bin/fd
```

```fish
# From Fish
ln -s (which fdfind) ~/.local/bin/fd
```

## Utility programs

Basic
- `uname` - basic system info
- `inxi` - detailed system info
- `htop` - CPU and ram loads

List commands
* `lscpu` - CPU info
* `lsmem` - memory info
* `lsusb` - USB info
* `lspci` - PCI devices info

Misc.
- `sensors` - sensor data (e.g., temperature)
- `acpi` - battery level
- `date` - current time

## Fish-related key-bindings & commands

- `fish_update_completions` - Update auto-complete

* `fish_vi_key_bindings` - vi mode
* `fish_default_key_bindings` - back to default

- <kbd>Alt</kbd> + <kbd>←</kbd> - previous directory
- <kbd>Alt</kbd> + <kbd>→</kbd> - previous directory

* <kbd>Alt</kbd> + <kbd>w</kbd> - what the typed command does
* <kbd>Alt</kbd> + <kbd>s</kbd> - prefix sudo to command
