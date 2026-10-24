# As a shortcut for running copy-to-config.sh
all:
	@./copy-to-config.sh

# Copy the Neovim plugin lockfile back after vim.pack.update
lock-nvim:
	@cp $${XDG_CONFIG_HOME:-$$HOME/.config}/nvim/nvim-pack-lock.json nvim/nvim-pack-lock.json
	@echo "Copied nvim-pack-lock.json from config"
