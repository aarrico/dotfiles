#!/usr/bin/env bash
# apps.sh - Isolated Tool & Version Manager Deployment Routine
set -euo pipefail

log_info() { echo -e "\033[0;34m[APPS]\033[0m $1"; }
log_warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }

SYSTEM_APPS=(
    tmux neovim visual-studio-code-bin git ripgrep 
    bat lazygit github-cli zoxide fnm uv ttf-jetbrains-mono-nerd
)

log_info "Synchronizing core developer app ecosystems..."
for app in "${SYSTEM_APPS[@]}"; do
    if ! paru -Qi "$app" &>/dev/null && ! pacman -Qi "$app" &>/dev/null; then
        log_info "Installing application binary via native helper: $app"
        paru -S --noconfirm "$app"
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

# =====================================================================
# INTERACTIVE GITHUB & CREDENTIAL PROVISIONING
# =====================================================================
echo ""
log_info "Evaluating GitHub environment setup..."

if command -v gh &>/dev/null; then
    echo -n -e "\033[0;33m[PROMPT]\033[0m Would you like to authenticate GitHub CLI and register an SSH key? (y/N): "
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        # 1. Handle GH CLI Authentication
        if ! gh auth status &>/dev/null; then
            log_info "Launching interactive GitHub CLI authentication login..."
            gh auth login --web --git-protocol ssh
        else
            log_info "GitHub CLI is already authenticated."
        fi

        # 2. Handle SSH Key Generation
        SSH_KEY="$HOME/.ssh/github"
        if [ ! -f "$SSH_KEY" ]; then
            log_info "No Ed25519 SSH key detected. Generating a new secure keypair..."
            echo -n -e "\033[0;33m[PROMPT]\033[0m Enter your GitHub email address: "
            read -r gh_email
            
            mkdir -p "$HOME/.ssh"
            chmod 700 "$HOME/.ssh"
            ssh-keygen -t ed25519 -C "$gh_email" -f "$SSH_KEY" -N ""
            
            # Start agent and add key locally
            eval "$(ssh-agent -s)"
            ssh-add "$SSH_KEY"
        else
            log_info "Existing SSH key discovered at $SSH_KEY."
        fi
	
	# 3. Configure local SSH routing for the custom 'github' key name
        log_info "Configuring SSH local config file for custom key routing..."
        SSH_CONFIG="$HOME/.ssh/config"
        
        # Ensure the file exists with strict secure permissions
        touch "$SSH_CONFIG"
        chmod 600 "$SSH_CONFIG"

        if ! grep -q "Host github.com" "$SSH_CONFIG"; then
            cat << EOF >> "$SSH_CONFIG"

# Dedicated routing profile for GitHub using custom identity keys
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes
EOF
            log_info "SSH config route cleanly mapped to ~/.ssh/github."
        else
            log_info "An entry for github.com already exists in your SSH config."
        fi
        
	# 4. Register the SSH Key with GitHub via the CLI
        log_info "Checking if this machine's SSH key is registered with your GitHub account..."
        DEVICE_NAME="DevBox-$(hostname)-$(date +%Y%m%d)"
        
        # Check if the public key content already exists on the profile to maintain idempotency
        PUB_KEY_CONTENT=$(cat "${SSH_KEY}.pub")
        if ! gh ssh-key list | grep -q "$PUB_KEY_CONTENT"; then
            log_info "Uploading public key to GitHub profile as: '$DEVICE_NAME'"
            gh ssh-key add "${SSH_KEY}.pub" --title "$DEVICE_NAME"
            log_info "SSH key registered successfully!"
        else
            log_info "This specific SSH key is already registered on your GitHub account."
        fi
    else
        log_info "Skipping GitHub authentication and key registration."
    fi
else
    log_warn "GitHub CLI ('gh') was not detected. Authentication step skipped."
fi

echo ""
log_info "All application runtimes, font architectures, and language managers provisioned!"
