#!/usr/bin/env bash
# PAI Tool - Utility functions

# Check if a command exists
pai_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Log message with timestamp
pai_log() {
  local level="$1"
  local message="$2"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] [$level] $message"
}

# Log info message
pai_info() {
  pai_log "INFO" "$1"
}

# Log error message
pai_error() {
  pai_log "ERROR" "$1" >&2
}

# Log warning message
pai_warn() {
  pai_log "WARN" "$1"
}

# Check for required dependencies
pai_check_dependencies() {
  local missing=""
  
  for cmd in curl git; do
    if ! pai_command_exists "$cmd"; then
      missing="$missing $cmd"
    fi
  done
  
  if [ -n "$missing" ]; then
    pai_error "Missing required dependencies:$missing"
    pai_error "Please install these dependencies and try again."
    return 1
  fi
  
  return 0
}

# Check for Node.js and npm
pai_check_node() {
  if ! pai_command_exists "node"; then
    pai_error "Node.js is not installed."
    pai_error "Please install Node.js from https://nodejs.org/"
    return 1
  fi
  
  if ! pai_command_exists "npm"; then
    pai_error "npm is not installed."
    pai_error "Please install npm, which usually comes with Node.js"
    return 1
  fi
  
  local node_version=$(node -v | cut -d 'v' -f 2)
  pai_info "Node.js version: $node_version"
  
  return 0
}

# Install Node.js package using npm
pai_npm_install() {
  local package="$1"
  
  pai_info "Installing Node.js package: $package"
  
  if npm install -g "$package"; then
    pai_info "Successfully installed $package"
    return 0
  else
    pai_error "Failed to install $package"
    return 1
  fi
}

# Check if a Node.js package is installed
pai_npm_check_installed() {
  local package="$1"
  
  npm list -g "$package" >/dev/null 2>&1
  return $?
}

# Download a file from URL
pai_download() {
  local url="$1"
  local output="$2"
  
  if pai_command_exists curl; then
    curl -sSL "$url" -o "$output"
  elif pai_command_exists wget; then
    wget -q "$url" -O "$output"
  else
    pai_error "Neither curl nor wget found. Please install one of them."
    return 1
  fi
  
  return 0
}

# Create directory if it doesn't exist
pai_ensure_dir() {
  local dir="$1"
  
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir" || {
      pai_error "Failed to create directory: $dir"
      return 1
    }
  fi
  
  return 0
}

# Check if running latest version
pai_check_version() {
  local current_version="$PAI_VERSION"
  local latest_version
  
  pai_info "Current version: $current_version"
  pai_info "Checking for updates..."
  
  # Implementation will pull latest version from GitHub
  # latest_version=$(curl -sSL https://raw.githubusercontent.com/yourusername/pai-tool/main/VERSION)
  
  # Temporary placeholder
  latest_version="$current_version"
  
  if [ "$current_version" != "$latest_version" ]; then
    pai_info "New version available: $latest_version"
    return 1
  else
    pai_info "You are using the latest version"
    return 0
  fi
}
