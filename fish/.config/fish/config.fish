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
# set -gx PYTHONPATH (pip show pip | grep "Location" | string split ": " -f2)

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

    set PATH "$PATH":"$HOME/.local/scripts/"
    set PATH "$PATH":"$HOME/.cargo/bin"
    bind \cf tmux-sessionizer
    bind \ch "tmux-sessionizer -s 0"
    bind \cz 'fg 2>/dev/null; commandline -f repaint' # CTRL + Z to return to sleeping helix

end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/wv/miniconda3/bin/conda
    eval /home/wv/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/home/wv/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/wv/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /home/wv/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<

# Re-assert conda env's bin before mise shims on every prompt.
# Needed because mise's fish_prompt hook re-runs mise hook-env (which puts
# mise shims first), overriding whatever conda activate just prepended.
# Defining this AFTER mise activate ensures it fires after mise's hook.
function __conda_priority --on-event fish_prompt
    if set -q CONDA_PREFIX; and test "$CONDA_DEFAULT_ENV" != "base"
        set -l conda_bin "$CONDA_PREFIX/bin"
        if test "$PATH[1]" != "$conda_bin"
            set -gx PATH (string match -rv "^$conda_bin\$" -- $PATH)
            set -gx PATH $conda_bin $PATH
        end
    end
end
