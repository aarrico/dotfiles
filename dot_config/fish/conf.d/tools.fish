if status is-interactive
    starship init fish | source

    if type -q zoxide
        zoxide init fish | source
    end
    if type -q uv
        uv generate-shell-completion fish | source
    end

    set -gx FZF_DEFAULT_OPTS "--height 45% --layout=reverse --border=rounded --inline-info --color='pointer:#7dcfff,hdr:#bb9af7,info:#e0af68,marker:#9ece6a'"
    set -gx fzf_fd_opts --hidden --exclude .git --exclude node_modules --exclude .cache

    if type -q eza
        alias ll="eza -l --icons --git --group-directories-first --time-style=long-iso"
        alias la="eza -la --icons --git --group-directories-first --time-style=long-iso"
        alias lt="eza --tree --level=2 --icons"
    end
    alias g="git"
    alias gaa="git add ."
    alias gp="git push"
    alias gl="git pull"
    alias gst="git status"
    alias gd="git diff"
    alias gaa="git add ."
    alias gp="git push"
    alias gl="git pull"
    alias gst="git status"
    alias gd="git diff"
    alias dfu="dotfiles_update"
    alias v="nvim"
    alias vim="nvim"
    alias vi="nvim"
    alias lg="lazygit"
    alias cat="bat --style=plain"
end
