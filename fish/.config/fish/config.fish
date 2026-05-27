source /usr/share/cachyos-fish-config/cachyos-config.fish

function fish_greeting
end

# asdf version manager
if test -f "$HOME/.asdf/asdf.fish"
    source "$HOME/.asdf/asdf.fish"
else
    if test -z "$ASDF_DATA_DIR"
        set _asdf_shims "$HOME/.asdf/shims"
    else
        set _asdf_shims "$ASDF_DATA_DIR/shims"
    end
    if not contains $_asdf_shims $PATH
        set -gx --prepend PATH $_asdf_shims
    end
    set --erase _asdf_shims
end

# ~/.bin
if test -d "$HOME/.bin"
    if not contains "$HOME/.bin" $PATH
        set -gx --prepend PATH "$HOME/.bin"
    end
end

# ssh-agent
if test -n "$XDG_RUNTIME_DIR" -a -S "$XDG_RUNTIME_DIR/ssh-agent.socket"
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
end

# Aliases
alias l='eza -l --icons'
alias ll='eza -la --icons'
alias tree='eza --tree --icons'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias ga='git add'

starship init fish | source
