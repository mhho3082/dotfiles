# Shell tips

## One-liners

Read the system log:

```bash
journalctl -xe
```

Find the largest files/directories in a directory:
(Helpful when clearing out disk space)

```bash
# Change `~` to the desired directory, or remove for current directory
du ~ -h -d 1 | sort -hr
```

Remove a package completely and safely with `pacman`:
(From [Reddit](https://www.reddit.com/r/archlinux/comments/ki9hmm))

```bash
# Replace "package" with package name
# You can replace `pacman` with `paru` here
pacman -Runs package
```

Show all installed packages:

```bash
pacman -Qet
```

Pipe from/to clipboard with `xsel`:

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
(From [Stack Overflow](https://stackoverflow.com/q/11680815))

```bash
sed -e 's/\r//g' file.txt # replace with file name
```

Test for 256-colours for your terminal emulator:
(From [Ask Ubuntu](https://askubuntu.com/q/821157))

```bash
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

Symlink to "rename" programs, e.g., `fdfind` to `fd`:

```bash
ln -s $(which fdfind) ~/.local/bin/fd
```

Login to GitHub CLI:

```bash
gh auth login
```

Background / foreground jobs:

```bash
# create a job to background
nvim &

# Pull the background job to foreground
fg
```

Reduce `paru` cache:

```bash
paru -Sc
```

Fix cannot update `npm` by `pacman`:

```bash
# https://bbs.archlinux.org/viewtopic.php?id=272138
pacman --overwrite "*" -S npm
```

Get size of all installed Arch packages:

```bash
pacman -Qi | awk '/Installed Size/ {print $4$5}' | sed 's/[^0-9.]*//g' | paste -sd+ - | bc
```

## Utility programs

Basic

- `uname` - basic system info
- `inxi` - detailed system info
- `htop` - CPU and ram loads

List commands

- `lscpu` - CPU info
- `lsmem` - memory info
- `lsusb` - USB info
- `lspci` - PCI devices info

Misc.

- `sensors` - sensor data (e.g., temperature)
- `acpi` - battery level
- `date` - current time
