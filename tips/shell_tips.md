## One-liners

Find the largest directories in ~/

```bash
du ~ -h -d 1 | sort -hr
```

Remove a package fully and safely with `pacman`:
From [Reddit](https://www.reddit.com/r/archlinux/comments/ki9hmm/how_to_properly_removeuninstall_packagesapps_with/)

```bash
pacman -Runs package
```

## Utilities

Basic
`uname -a` - basic system info
`inxi` - detailed system info
`htop` - CPU and ram loads

The `ls*` commands
`lscpu` - CPU info
`lsmem` - memory info
`lsusb` - USB info
`lspci` - PCI devices info

Misc.
`sensors` - sensor data (e.g., temperature)
`acpi` - battery level
`date` - current time
