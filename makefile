# As a shortcut for running copy_to_config.sh
all:
	@./copy_to_config.sh

# An auto-confirm version (no need to check diff)
yes:
	@./copy_to_config.sh -y
y: yes
