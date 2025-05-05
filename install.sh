#!/usr/bin/env bash
# PAI Tool Installer

set -e

PAI_REPO="https://github.com/bachlee89/pai-tool.git"
PAI_DIR="${HOME}/.pai"
PAI_PROFILES=("${HOME}/.bashrc" "${HOME}/.zshrc" "${HOME}/.profile")

# Function to print messages
print_message() {
  printf "\\033[0;32m%s\\033[0m\\n" "$1"
}

# Function to print error messages
print_error() {
  printf "\\033[0;31m%s\\033[0m\\n" "$1" >&2
}

# Function to check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
  local missing=""
  
  for cmd in curl git; do
    if ! command_exists "$cmd"; then
      missing="$missing $cmd"
    fi
  done
  
  if [ -n "$missing" ]; then
    print_error "Missing required dependencies:$missing"
    print_error "Please install these dependencies and try again."
    exit 1
  fi
}

# Download PAI
download_pai() {
  print_message "Downloading PAI Tool..."
  
  if [ -d "$PAI_DIR" ]; then
    print_message "PAI Tool directory already exists, updating..."
    cd "$PAI_DIR" && git pull origin main
  else
    print_message "Installing PAI Tool to $PAI_DIR..."
    mkdir -p "$PAI_DIR"
    git clone "$PAI_REPO" "$PAI_DIR"
  fi
  
  # Make scripts executable
  chmod +x "$PAI_DIR/pai.sh"
  if [ -f "$PAI_DIR/lib/utils.sh" ]; then
    chmod +x "$PAI_DIR/lib/utils.sh"
  fi
}

# Update shell configuration
update_shell_config() {
  print_message "Updating shell configuration..."
  
  local config_line="export PATH=\"\$PATH:\$HOME/.pai\""
  # Use alias to safely run PAI commands when sourced
  local source_line="[ -s \"\$HOME/.pai/pai.sh\" ] && source \"\$HOME/.pai/pai.sh\" # This loads PAI Tool without closing terminal"
  local alias_line="alias pai=\"\$HOME/.pai/pai.sh\""
  
  for profile in "${PAI_PROFILES[@]}"; do
    if [ -f "$profile" ]; then
      if ! grep -q "PATH.*\.pai" "$profile"; then
        print_message "Adding PAI to PATH in $profile"
        echo -e "\n# PAI Tool" >> "$profile"
        echo "$config_line" >> "$profile"
      fi
      
      # Remove old sourcing if exists
      if grep -q "\[ -s.*\.pai/pai.sh" "$profile" && ! grep -q "source.*\.pai/pai.sh.*without closing terminal" "$profile"; then
        print_message "Updating PAI source in $profile"
        grep -v "\[ -s.*\.pai/pai.sh" "$profile" > "$profile.tmp"
        mv "$profile.tmp" "$profile"
      fi
      
      # Add new sourcing method
      if ! grep -q "source.*\.pai/pai.sh" "$profile"; then
        print_message "Adding PAI source in $profile"
        echo "$source_line" >> "$profile"
      fi
      
      # Add pai alias if missing
      if ! grep -q "alias pai='.*pai.sh'" "$profile"; then
        print_message "Adding PAI alias in $profile"
        echo "$alias_line" >> "$profile"
      fi
    fi
  done
}

# Create a symbolic link to pai.sh
create_symlink() {
  print_message "Creating symbolic link..."
  
  local bin_dir="$HOME/bin"
  if [ ! -d "$bin_dir" ]; then
    mkdir -p "$bin_dir"
  fi
  
  # Create symlink if not already existing
  if [ ! -e "$bin_dir/pai" ]; then
    ln -s "$PAI_DIR/pai.sh" "$bin_dir/pai"
    print_message "Symbolic link created at $bin_dir/pai"
  else
    print_message "Symbolic link already exists"
  fi
  
  # Check if bin directory is in PATH
  if ! echo "$PATH" | grep -q "$bin_dir"; then
    print_message "Adding $bin_dir to PATH"
    for profile in "${PAI_PROFILES[@]}"; do
      if [ -f "$profile" ]; then
        if ! grep -q "PATH.*bin" "$profile"; then
          echo -e "\n# Adding ~/bin to PATH" >> "$profile"
          echo "export PATH=\"\$PATH:\$HOME/bin\"" >> "$profile"
        fi
      fi
    done
  fi
}

# Main installation process
main() {
  print_message "Installing PAI Tool..."
  
  check_dependencies
  download_pai
  update_shell_config
  create_symlink
  
  print_message "PAI Tool has been installed successfully!"
  print_message "Please restart your terminal or run 'source ~/.bashrc' (or your shell's config file) to use pai."
  print_message "To verify installation, run: pai version"
}

# Run the installation
main
