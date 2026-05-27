# Shell Configuration Entrypoint
# Path: ~/.config/fish/config.fish

if status is-interactive
    # --- Prompt Architecture Setup ---
    starship init fish | source

    # --- Structural Environment Aliases ---
    if type -q eza
        alias ll="eza -l --icons --git --group-directories-first --time-style=long-iso"
        alias la="eza -la --icons --git --group-directories-first --time-style=long-iso"
        alias lt="eza --tree --level=2 --icons"
    else
        alias ll="ls -lh --color=auto"
        alias la="ls -lah --color=auto"
    end 
    alias g="git"
    alias gaa="git add ."
    alias gp="git push"
    alias gl="git pull"
    alias gst="git status"
    alias gd="git diff"
    alias dfu="dotfiles_update"
    alias v="nvim"
    alias lg="lazygit"
    alias cat="bat --style=plain"
    alias cheat="xdg-open \$dotfiles_repo_dir/index.html"
    
    # --- Heavy Engine Interventions: Advanced FZF ---
    set -gx FZF_DEFAULT_OPTS "--height 45% --layout=reverse --border=rounded --inline-info --color='pointer:#7dcfff,hdr:#bb9af7,info:#e0af68,marker:#9ece6a'"
    set -gx fzf_fd_opts --hidden --exclude .git --exclude node_modules --exclude .cache

    # --- Lean Performance Environment Tool Intersections ---
    if type -q zoxide
        zoxide init fish | source
    end
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end
    if type -q uv
        uv generate-shell-completion fish | source
    end
end
