## Update

To update after modifying with Fcitx 5 Configuration GUI tool:

```bash
rsync -av --exclude='cached_layouts' ~/.config/fcitx5/config ./fcitx5/
rsync -av --exclude='cached_layouts' ~/.config/fcitx5/conf/ ./fcitx5/conf
```
