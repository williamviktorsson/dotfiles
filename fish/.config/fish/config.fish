# ~/.config/fish/config.fish

# =============================================================================
# Universal Configuration (runs in ALL shell sessions)
# =============================================================================

# mise (version manager)
if command -v mise >/dev/null
    mise activate fish | source
end

# zoxide (directory jumper)
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# Environment Variables
set -q EDITOR; or set -gx EDITOR helix
set -gx SUDO_EDITOR "$EDITOR"
set -gx BAT_THEME ansi

# =============================================================================
# Interactive-Only Configuration
# =============================================================================

if status is-interactive
    # Remove the greeting message
    set -U fish_greeting ""

    # starship (prompt)
    if command -v starship >/dev/null
        starship init fish | source
    end

    # fzf (fuzzy finder key bindings)
    if command -v fzf >/dev/null
        fzf --fish | source
    end

    # --- Aliases ---

    # File system
    if command -v eza >/dev/null
        alias ls 'eza -lh --group-directories-first --icons=auto'
        alias lsa 'ls -a'
        alias lt 'eza --tree --level=2 --long --icons --git'
        alias lta 'lt -a'
    end

    # Custom `cd` wrapper for zoxide (the `zd` function will be autoloaded)
    alias cd zd

    # Directories
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'

    # Tools
    alias d docker
    alias r rails

    # Git
    alias g git
    alias gcm 'git commit -m'
    alias gcam 'git commit -a -m'
    alias gcad 'git commit -a --amend'

    # Editor shortcuts (the `hx` function will be autoloaded)
    alias h hx
    alias n nautilus

    # Other aliases
    alias decompress "tar -xzf"
    alias ff "fzf --preview 'bat --style=numbers --color=always {}'"
end
