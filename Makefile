# Variables
NVIM_CONFIG_DIR ?= $(HOME)/.config/nvim
LUA_CONFIG_DIR ?= $(NVIM_CONFIG_DIR)/lua/ashrahma
AFTER_CONFIG_DIR ?= $(NVIM_CONFIG_DIR)/after
AFTER_PLUGIN_DIR ?= $(NVIM_CONFIG_DIR)/after/plugin
AFTER_TMP_DIR ?= $(NVIM_CONFIG_DIR)/after.tmp
PACKER_DIR ?= $(HOME)/.local/share/nvim/site/pack/packer/start/packer.nvim

# Lua config files
AFTER_LUA_FILES ?= $(wildcard $(AFTER_PLUGIN_DIR)/*.lua)

# Shell function to indent output by 2 spaces (for === messages)
define indent2
    echo "\n  $1"
endef

# Shell function to indent output by 4 spaces (for regular messages)
define indent4
    echo "    $1"
endef

# Default target
all: install

# Install target
install: move-after-dir structure-setup install-packer sync-plugins move-back-after-dir source-after-config
	@$(call indent2, "=== Neovim setup complete! ===")

# Move after directory to after.tmp
move-after-dir:
	@$(call indent2, "=== Moving after directory to after.tmp ===")
	@if [ -d "$(AFTER_CONFIG_DIR)" ]; then \
		$(call indent4, "Moving $(AFTER_CONFIG_DIR) to $(AFTER_TMP_DIR)..."); \
		mv "$(AFTER_CONFIG_DIR)" "$(AFTER_TMP_DIR)"; \
	else \
		$(call indent4, "after directory not found. Skipping move..."); \
	fi

# Move after.tmp back to after directory
move-back-after-dir:
	@$(call indent2, "=== Moving after.tmp back to after directory ===")
	@if [ -d "$(AFTER_TMP_DIR)" ]; then \
		$(call indent4, "Moving $(AFTER_TMP_DIR) back to $(AFTER_CONFIG_DIR)..."); \
		mv "$(AFTER_TMP_DIR)" "$(AFTER_CONFIG_DIR)"; \
	else \
		$(call indent4, "after.tmp directory not found. Skipping move..."); \
	fi

# Set up project structure
structure-setup:
	@$(call indent2, "=== Setting up project structure ===")
	
	@$(call indent4, "Sourcing static files...")
	@nvim --headless -c "luafile $(LUA_CONFIG_DIR)/remap.lua" -c "qa!"
	@nvim --headless -c "luafile $(LUA_CONFIG_DIR)/set.lua" -c "qa!"

	@$(call indent4, "Sourcing init files...")
	@nvim --headless -c "luafile $(LUA_CONFIG_DIR)/init.lua" -c "qa!"
	@nvim --headless -c "luafile $(NVIM_CONFIG_DIR)/init.lua" -c "qa!"

# Install packer.nvim
install-packer:
	@$(call indent2, "=== Step 1: Installing packer.nvim ===")
	@$(call indent4, "Checking if packer.nvim is already installed...")
	@if [ ! -d "$(PACKER_DIR)" ]; then \
		$(call indent4, "packer.nvim not found. Installing..."); \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER_DIR); \
		$(call indent4, "packer.nvim installed successfully."); \
	else \
		$(call indent4, "packer.nvim is already installed. Skipping..."); \
	fi

# Sync plugins
sync-plugins:
	@$(call indent2, "=== Step 2: Syncing plugins with :PackerSync ===")
	@$(call indent4, "Running :PackerSync to install/update plugins...")
	@nvim --headless -c "luafile $(LUA_CONFIG_DIR)/packer.lua" -c "PackerSync" -c "qa!"
	@$(call indent2, "=== Step 2 complete: Plugins synced. ===")

# Source after directory (only after plugins are installed)
source-after-config:
	@$(call indent2, "=== Step 3: Sourcing after directory configuration files ===")
	@$(call indent4, "Lua files to source: $(AFTER_LUA_FILES)")
	@for file in $(AFTER_LUA_FILES); do \
		$(call indent4, "Sourcing $$file..."); \
		nvim --headless -c "luafile $$file" -c "qa!"; \
	done
	@$(call indent2, "=== Step 3 complete: All after directory configuration files sourced. ===")

# Reinstall packer.nvim
reinstall-packer:
	@$(call indent2, "=== Reinstalling packer.nvim ===")
	@$(call indent4, "Removing existing packer.nvim installation...")
	@rm -rf $(PACKER_DIR)
	@$(call indent4, "Reinstalling packer.nvim...")
	@git clone --depth 1 https://github.com/wbthomason/packer.nvim $(PACKER_DIR)
	@$(call indent4, "Sourcing packer.lua to reinitialize packer.nvim...")
	@nvim --headless -c "luafile $(LUA_CONFIG_DIR)/packer.lua" -c "qa!"
	@$(call indent4, "Running :PackerSync to reinstall plugins...")
	@nvim --headless -c "PackerSync" -c "qa!"
	@$(call indent2, "=== packer.nvim reinstalled and plugins synced. ===")

fetch-latest:
	@$(call indent2, "=== Checking for uncommitted changes ===")
	@if git diff --quiet && git diff --cached --quiet; then \
		$(call indent4, "Working tree is clean. Proceeding..."); \
	else \
		$(call indent4, "Uncommitted changes found. Resetting working tree..."); \
		git reset --hard > /dev/null 2>&1; \
		$(call indent4, "Working tree reset successfully."); \
	fi

	@$(call indent2, "=== Fetching latest changes ===")
	@git fetch origin > /dev/null 2>&1
	@$(call indent2, "=== Latest changes fetched. ===")

	@$(call indent2, "=== Pulling latest changes from master branch ===")
	@git pull origin master > /dev/null 2>&1
	@$(call indent2, "=== Latest changes pulled successfully. ===")

# Update target
update: fetch-latest move-after-dir structure-setup install-packer sync-plugins move-back-after-dir source-after-config
	@$(call indent2, "=== Neovim configuration updated! ===")

# Help target
help:
	@echo "Usage: make [target]"
	@echo ""
	@$(call indent2, "install           - Install Neovim configuration and plugins")
	@$(call indent2, "install-packer    - Install or update packer.nvim")
	@$(call indent2, "sync-plugins      - Run :PackerSync to install/update plugins")
	@$(call indent2, "source-after-config - Source after directory configuration files")
	@$(call indent2, "reinstall-packer  - Reinstall packer.nvim and sync plugins")
	@$(call indent2, "update            - Update Neovim configuration by fetching and pulling latest changes")
	@$(call indent2, "help              - Show this help message")
