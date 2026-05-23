#!/usr/bin/env bash
# install.sh - Idempotent Dotfiles Core Config Engine
set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Formatting Escapes
RC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'

log_info()    { echo -e "${BLUE}[INFO]${RC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${RC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${RC} $1"; }

echo "=================================================="
echo "    Deploying Tokyo Night Dev Ecosystem Layout     "
echo "=================================================="

# Check and boot baseline shell tools
log_info "Ensuring core baseline package targets exist..."
REQUIRED_PKGS=(fish starship fzf fd eza git)
MISSING_PKGS=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    command -v "$pkg" &>/dev/null || MISSING_PKGS+=("$pkg")
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    log_info "Installing system essentials via pacman: ${MISSING_PKGS[*]}"
    sudo pacman -S --noconfirm "${MISSING_PKGS[@]}"
fi

# Switch interactive context to fish shell cleanly if needed
if [ "$(basename "$SHELL")" != "fish" ]; then
    log_info "Switching system shell profile configuration to Fish..."
    chsh -s "$(command -v fish)"
fi

# Clean, safe symlinking engine with automatic backups
link_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ -L "$dest" ] && [ "$(readlink "$dest")" == "$src" ]; then
            return
        fi
        log_warn "Conflicting configuration target found at $dest. Creating backup snapshot..."
        mv "$dest" "${dest}.bak_$(date +%Y%m%d_%H%M%S)"
    fi
    log_info "Linking: $dest -> $src"
    ln -s "$src" "$dest"
}

# Deploy tool links
link_file "$DOTFILES_DIR/config/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
link_file "$DOTFILES_DIR/config/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
link_file "$DOTFILES_DIR/config/fish/fish_plugins" "$XDG_CONFIG_HOME/fish/fish_plugins"
link_file "$DOTFILES_DIR/config/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
link_file "$DOTFILES_DIR/config/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
link_file "$DOTFILES_DIR/config/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
link_file "$DOTFILES_DIR/config/nvim/lua/config/options.lua" "$XDG_CONFIG_HOME/nvim/lua/config/options.lua"
link_file "$DOTFILES_DIR/config/nvim/lua/config/keymaps.lua" "$XDG_CONFIG_HOME/nvim/lua/config/keymaps.lua"
link_file "$DOTFILES_DIR/config/nvim/lua/config/lazy.lua" "$XDG_CONFIG_HOME/nvim/lua/config/lazy.lua"
link_file "$DOTFILES_DIR/config/nvim/lua/plugins/developer.lua" "$XDG_CONFIG_HOME/nvim/lua/plugins/developer.lua"

# Dynamic function linking block
for func_file in "$DOTFILES_DIR/config/fish/functions"/*.fish; do
    if [ -f "$func_file" ]; then
        link_file "$func_file" "$XDG_CONFIG_HOME/fish/functions/$(basename "$func_file")"
    fi
done

# Bootstrap Fisher Plugin Manager
if ! fish -c "functions -q fisher" &>/dev/null; then
    log_info "Bootstrapping Fisher package index inside native shell environment..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fi
log_info "Syncing shell plugin layout configurations..."
fish -c "fisher update"

# Establish tracking variables for hot-updates (dfu)
log_info "Registering repository anchor paths for shell hot-updates..."
fish -c "set -U dotfiles_repo_dir '$DOTFILES_DIR'"

log_success "Core environment configurations successfully linked!"
echo "Run ./apps.sh now to provision your tools, fonts, and compiler managers."
