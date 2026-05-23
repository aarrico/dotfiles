#!/usr/bin/env bash
# apps.sh - Isolated Tool & Version Manager Deployment Routine
set -euo pipefail

log_info() { echo -e "\033[0;34m[APPS]\033[0m $1"; }
log_warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }

SYSTEM_APPS=(
    tmux neovim visual-studio-code-bin git ripgrep 
    bat lazygit github-cli zoxide fnm uv ttf-jetbrains-mono-nerd
)

log_info "Synchronizing core developer app ecosystems via pacman..."
for app in "${SYSTEM_APPS[@]}"; do
    if ! pacman -Qi "$app" &>/dev/null; then
        log_info "Installing application binary: $app"
        sudo pacman -S --noconfirm "$app"
    fi
done

# Initialize FNM local user paths dynamically for the initial setup block
log_info "Configuring FNM isolated background Node runtimes..."
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"
if ! fnm current &>/dev/null; then
    log_info "Provisioning latest Node.js LTS engine..."
    fnm install --lts
    fnm default lts
fi

# Install Claude Code CLI globally through the freshly configured FNM pathing
log_info "Auditing global Node package space for CLI modules..."
FNM_NODE_PATH=$(fnm env | grep -oP '(?<=--multishell-path=)[^"\s]+' || echo "")
if [ -n "$FNM_NODE_PATH" ] && [ -d "$FNM_NODE_PATH" ]; then
    export PATH="$FNM_NODE_PATH:$PATH"
    if ! command -v claude &>/dev/null; then
        log_info "Installing Anthropic Claude Code engine globally..."
        npm install -g @anthropic-ai/claude-code
    fi
else
    log_warn "Active FNM multitrack lookup suspended; tool execution will cycle on shell initialization."
fi

# Rehydrate fonts system cache
log_info "Flushing system font cache maps for JetBrains Mono font profiles..."
fc-cache -fv &>/dev/null

log_info "All application runtimes, font architectures, and language managers provisioned!"
