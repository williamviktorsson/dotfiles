#!/bin/bash

# A script to ensure stow is installed and then stow all dotfile packages,
# ignoring specific folders like 'installation-scripts'.

STOW_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET_DIR="$HOME"
# Define folders to ignore during the stowing process
FOLDERS_TO_IGNORE=("installation-scripts")

# --- Helper Functions for Colored Output ---
print_info() { echo -e "\e[34mINFO: $1\e[0m"; }
print_success() { echo -e "\e[32mSUCCESS: $1\e[0m"; }
print_error() { echo -e "\e[31mERROR: $1\e[0m"; }

# --- 1. Check and Install GNU Stow ---
print_info "Checking for GNU Stow..."
if command -v stow &> /dev/null; then
    print_success "Stow is already installed."
else
    # (Installation logic is the same as before...)
    print_info "Stow not found. Attempting to install..."
    sudo -v
    #if command -v apt-get &> /dev/null; then sudo apt-get update && sudo apt-get install stow -y;
    #elif command -v dnf &> /dev/null; then sudo dnf install stow -y;
    #el
    if command -v pacman &> /dev/null; then sudo pacman -S stow --noconfirm;
    #elif command -v brew &> /dev/null; then brew install stow;
    else
        print_error "Could not detect a supported package manager. Please install stow manually."
        exit 1
    fi
    if ! command -v stow &> /dev/null; then print_error "Stow installation failed."; exit 1; fi
    print_success "Stow has been installed successfully."
fi

# --- 2. Identify and Stow All Packages ---
print_info "Identifying packages to stow..."
PACKAGES_TO_STOW=()
# Loop through all items in the base directory
for item in "$STOW_DIR"/*; do
    # Check if it's a directory
    if [ -d "$item" ]; then
        pkg_name=$(basename "$item")
        should_ignore=false
        # Check if the directory is in our ignore list
        for ignored in "${FOLDERS_TO_IGNORE[@]}"; do
            if [[ "$pkg_name" == "$ignored" ]]; then
                print_info "Ignoring directory: $pkg_name"
                should_ignore=true
                break
            fi
        done
        # If not ignored, add it to our list of packages
        if ! $should_ignore; then
            PACKAGES_TO_STOW+=("$pkg_name")
        fi
    fi
done

if [ ${#PACKAGES_TO_STOW[@]} -gt 0 ]; then
    print_info "Stowing packages: ${PACKAGES_TO_STOW[*]}"
    # Use the array to stow all valid packages at once
    stow --dir="$STOW_DIR" --target="$TARGET_DIR" -v -R "${PACKAGES_TO_STOW[@]}"
    print_success "All packages have been stowed successfully!"
else
    print_info "No packages found to stow."
fi
