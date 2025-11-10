#!/bin/bash

# A script to safely adopt a configuration file into a stow-managed dotfiles repository.
# It creates the necessary directory structure, prevents overwrites, creates a
# placeholder installation script, and then opens that script in your default editor.

# --- Configuration ---
STOW_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
STOW_TARGET="$HOME"
INSTALL_SCRIPTS_DIR="$STOW_DIR/installation-scripts"
OPEN_EDITOR_ON_CREATE=true

# --- Helper Functions for Colored Output ---
print_info() { echo -e "\e[34mINFO: $1\e[0m"; }
print_success() { echo -e "\e[32mSUCCESS: $1\e[0m"; }
print_error() { echo -e "\e[31mERROR: $1\e[0m"; }
print_warn() { echo -e "\e[33mWARN: $1\e[0m"; }

# --- 1. Argument and Sanity Checks ---
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <package_name> <config_file_path>"
    exit 1
fi

PACKAGE_NAME="$1"
CONFIG_FILE="$2"

if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Source file '$CONFIG_FILE' not found or is not a regular file."
    exit 1
fi

ABSOLUTE_CONFIG_PATH=$(realpath "$CONFIG_FILE")

if [[ "$ABSOLUTE_CONFIG_PATH" != "$STOW_TARGET"* ]]; then
    print_error "The config file must be located within the stow target directory ($STOW_TARGET)."
    exit 1
fi

RELATIVE_PATH="${ABSOLUTE_CONFIG_PATH#$STOW_TARGET/}"
TARGET_FILE_IN_STOW_DIR="$STOW_DIR/$PACKAGE_NAME/$RELATIVE_PATH"

if [ -e "$TARGET_FILE_IN_STOW_DIR" ]; then
    print_error "A file or directory already exists at the target location:"
    print_error "  $TARGET_FILE_IN_STOW_DIR"
    echo "Aborting to prevent an overwrite."
    exit 1
fi

# --- 2. Manually Move the File and Re-Stow to Create the Link ---

print_info "Creating target directory: $(dirname "$TARGET_FILE_IN_STOW_DIR")"
mkdir -p "$(dirname "$TARGET_FILE_IN_STOW_DIR")"

print_info "Moving original file into the stow package..."
# THIS IS THE CRITICAL FIX: We manually move the file to its destination.
mv -v "$ABSOLUTE_CONFIG_PATH" "$TARGET_FILE_IN_STOW_DIR"
if [ $? -ne 0 ]; then
    print_error "Failed to move the file. Aborting."
    exit 1
fi

print_info "Running stow to create the new symlink..."
# Now we run stow. The -R (restow) flag will find the moved file
# inside the package and create the necessary symlink in the target directory.
stow --dir="$STOW_DIR" --target="$STOW_TARGET" -v -R "$PACKAGE_NAME"

print_success "Successfully integrated '$ABSOLUTE_CONFIG_PATH' into the '$PACKAGE_NAME' package."

# --- 3. Create a Placeholder Installation Script ---
mkdir -p "$INSTALL_SCRIPTS_DIR"
INSTALL_SCRIPT_PATH="$INSTALL_SCRIPTS_DIR/$PACKAGE_NAME.sh"

print_info "Checking for installation script..."
if [ -e "$INSTALL_SCRIPT_PATH" ]; then
    print_info "Installation script already exists at '$INSTALL_SCRIPT_PATH'. No action needed."
else
    print_info "Creating a new placeholder installation script..."
    echo "#!/bin/bash" > "$INSTALL_SCRIPT_PATH"
    echo "# TODO: Add installation steps for $PACKAGE_NAME" >> "$INSTALL_SCRIPT_PATH"
    echo "" >> "$INSTALL_SCRIPT_PATH"
    chmod +x "$INSTALL_SCRIPT_PATH"
    print_success "Created and made executable: $INSTALL_SCRIPT_PATH"

    # --- 4. Open New Script in Editor ---
    if [ "$OPEN_EDITOR_ON_CREATE" = true ]; then
        editor_cmd=${VISUAL:-$EDITOR}
        if [ -n "$editor_cmd" ]; then
            print_info "Opening new script in your default editor ($editor_cmd)..."
            $editor_cmd "$INSTALL_SCRIPT_PATH"
        else
            print_warn "Could not open editor. Set the \$VISUAL or \$EDITOR environment variable."
        fi
    fi
fi

echo ""
echo "Process complete."
