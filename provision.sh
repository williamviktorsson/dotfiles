#!/bin/bash

# Master installation script that:
# 1. Runs all installers in the 'installation-scripts' directory.
# 2. Runs the 'stow-all.sh' script to link all dotfiles.

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTALL_SCRIPTS_DIR="$DOTFILES_DIR/installation-scripts"

# --- Helper Functions for Colored Output ---
print_header() { echo -e "\n\e[1;35m--- $1 ---\e[0m"; }
print_info() { echo -e "\e[34mINFO: $1\e[0m"; }
print_warn() { echo -e "\e[33mWARN: $1\e[0m"; }
print_success() { echo -e "\e[32mSUCCESS: $1\e[0m"; }
print_error() { echo -e "\e[31mERROR: $1\e[0m"; }

# --- 1. Run Installation Scripts ---
print_header "Running Software Installers"
if [ ! -d "$INSTALL_SCRIPTS_DIR" ]; then
    print_warn "Installation scripts directory not found at '$INSTALL_SCRIPTS_DIR'."
else
    # Find all .sh files and loop through them
    for script in "$INSTALL_SCRIPTS_DIR"/*.sh; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            print_info "Checking script: $script_name"

            # Check if the script is functionally empty (ignores shebang, comments, and whitespace)
            # This is the updated, more robust check.
            if [ -z "$(grep -vE '^\s*#|^\s*$|^#!' "$script")" ]; then
                print_warn "Script '$script_name' is empty or contains only comments. Skipping."
                continue
            fi

            if [ -x "$script" ]; then
                print_info "Executing '$script_name'..."
                "$script"
                print_success "'$script_name' finished."
            else
                print_error "Script '$script_name' is not executable. Please run 'chmod +x $script'."
            fi
        fi
    done
fi
print_success "All installation scripts have been processed."

# --- 2. Run the Stow Script ---
print_header "Linking Dotfiles with Stow"
STOW_SCRIPT="$DOTFILES_DIR/stow-all.sh"

if [ -f "$STOW_SCRIPT" ]; then
    "$STOW_SCRIPT"
else
    print_error "The 'stow-all.sh' script was not found. Cannot link dotfiles."
    exit 1
fi

print_header "Setup Complete!"
