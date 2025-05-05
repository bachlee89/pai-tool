#!/usr/bin/env bash
# PAI Tool - Project AI Tooling
# A shell command tool for project management and initialization

# Determine if the script is being sourced or executed directly
# "$0" -ef "${BASH_SOURCE[0]}" will be true if the script is being executed directly
sourced=0
if [ -n "$BASH_VERSION" ] && [ "$0" != "${BASH_SOURCE[0]}" ]; then
  sourced=1
fi

# Prevent recursive sourcing
if [ $sourced -eq 1 ] && [ -n "$PAI_SOURCED" ]; then
  return 0
fi
export PAI_SOURCED=1

set -e

# Variables
PAI_VERSION="0.1.0"
# Determine the actual script location, resolving symlinks
PAI_SCRIPT="${BASH_SOURCE[0]}"
if [ -L "$PAI_SCRIPT" ]; then
  PAI_SCRIPT=$(readlink -f "$PAI_SCRIPT")
fi
PAI_DIR="$( cd "$( dirname "$PAI_SCRIPT" )" && pwd )"
PAI_LIB_DIR="$PAI_DIR/lib"
PAI_TEMPLATES_DIR="$PAI_DIR/templates"

# Source helper functions
if [ -f "$PAI_LIB_DIR/utils.sh" ]; then
  source "$PAI_LIB_DIR/utils.sh"
else
  echo "Error: Could not find utility functions"
  exit 1
fi

# Source MCP functions
if [ -f "$PAI_LIB_DIR/mcp.sh" ]; then
  source "$PAI_LIB_DIR/mcp.sh"
else
  echo "Warning: Could not find MCP functions"
fi

# Display help message
pai_help() {
  local command="$1"
  
  # Command-specific help
  if [ -n "$command" ]; then
    case "$command" in
      init)
        echo "PAI Tool - Initialize Project"
        echo ""
        echo "Usage: pai init [template]"
        echo ""
        echo "Templates:"
        echo "  cursor          Initialize a project with Cursor IDE configuration"
        echo "                  Creates .cursor/rules/ directory with configuration templates"
        echo "                  Also creates .cursor.json.sample and .cursor/mcp.json.sample"
        echo ""
        echo "  windsurf        Initialize a project with Windsurf rules for DevOps"
        echo "                  Creates .windsurfrules.sample file with DevOps best practices"
        echo "                  Includes guidelines for Bash, Ansible, Kubernetes, and more"
        echo "                  Also creates mcp_config.json.sample for MCP integration"
        echo "                  in ~/.codeium/windsurf/ directory"
        echo ""
        echo "Examples:"
        echo "  pai init cursor    Initialize a new project with Cursor IDE templates"
        echo "  pai init windsurf  Initialize a new project with Windsurf DevOps rules"
        echo ""
        echo "Notes:"
        echo "  - Templates are copied with .sample extension to avoid overwriting existing files"
        echo "  - Remove the .sample extension to activate the templates"
        ;;
      prompts)
        echo "PAI Tool - AI Prompts"
        echo ""
        echo "Usage: pai prompts"
        echo ""
        echo "Description:"
        echo "  Copies the AI prompts template file (PROMPTS.md) to the current directory."
        echo "  This template contains example prompts for various development and DevOps tasks."
        echo ""
        echo "Examples:"
        echo "  pai prompts     Create PROMPTS.md in the current directory"
        echo ""
        echo "Notes:"
        echo "  - If PROMPTS.md already exists, you will be prompted before overwriting"
        echo "  - Customize the template with your own project-specific prompts"
        ;;
      version)
        echo "PAI Tool - Version Information"
        echo ""
        echo "Usage: pai version [options]"
        echo ""
        echo "Options:"
        echo "  --check-update, -c   Check if a new version is available"
        echo ""
        echo "Examples:"
        echo "  pai version         Display version information"
        echo "  pai version -c      Display version and check for updates"
        echo ""
        echo "Notes:"
        echo "  - Use 'pai upgrade' to update to the latest version"
        ;;
      upgrade)
        echo "PAI Tool - Upgrade"
        echo ""
        echo "Usage: pai upgrade"
        echo ""
        echo "Description:"
        echo "  Updates PAI Tool to the latest version from the GitHub repository."
        echo "  Creates a backup of the current installation before upgrading."
        echo ""
        echo "Examples:"
        echo "  pai upgrade         Update PAI to the latest version"
        echo ""
        echo "Notes:"
        echo "  - A backup is created automatically in $PAI_DIR/backups/"
        echo "  - If the upgrade fails, it will automatically roll back to the previous version"
        ;;
      mcp)
        echo "PAI Tool - MCP Tools"
        echo ""
        echo "Usage: pai mcp <tool> [action]"
        echo ""
        echo "Tools:"
        echo "  browser-server (bs)  Manage Browser MCP Server for Cursor"
        echo ""
        echo "Actions for browser-server:"
        echo "  setup               Set up Browser MCP Server (default action)"
        echo "  start               Start the browser-tools-server"
        echo "  stop                Stop the browser-tools-server"
        echo "  status              Check the status of the browser-tools-server"
        echo ""
        echo "Examples:"
        echo "  pai mcp browser-server        Set up Browser MCP Server"
        echo "  pai mcp bs start              Start Browser MCP Server (short form)"
        echo "  pai mcp bs stop               Stop Browser MCP Server"
        echo ""
        echo "Notes:"
        echo "  - Requires Node.js and npm to be installed"
        echo "  - Sets up .cursor/mcp.json configuration file"
        echo "  - Browser extension must be installed separately"
        ;;
      plan)
        echo "PAI Tool - Project Planning"
        echo ""
        echo "Usage: pai plan"
        echo ""
        echo "Description:"
        echo "  Sets up project planning document templates in docs/planning directory."
        echo "  Creates the following template files with .sample extension:"
        echo "    - ROADMAP.md.sample - Project roadmap and milestones"
        echo "    - DESIGN.md.sample - Architecture and design decisions"
        echo "    - TASK.md.sample - Task tracking and progress"
        echo ""
        echo "Examples:"
        echo "  pai plan           Create planning document templates"
        echo ""
        echo "Notes:"
        echo "  - Templates are copied with .sample extension to avoid overwriting existing files"
        echo "  - Remove the .sample extension to activate the templates"
        echo "  - These documents help standardize project planning and documentation"
        ;;
      uninstall)
        echo "PAI Tool - Uninstall"
        echo ""
        echo "Usage: pai uninstall"
        echo ""
        echo "Description:"
        echo "  Completely removes the PAI Tool from your system."
        echo "  This will remove the PAI directory, symlinks, and configuration references."
        echo ""
        echo "Examples:"
        echo "  pai uninstall     Uninstall PAI Tool from your system"
        echo ""
        echo "Notes:"
        echo "  - You will be prompted for confirmation before uninstallation"
        echo "  - This action cannot be undone, but you can reinstall using the install script"
        ;;
      help)
        echo "PAI Tool - Help"
        echo ""
        echo "Usage: pai help [command]"
        echo ""
        echo "Description:"
        echo "  Displays help information for PAI Tool commands."
        echo "  If a command is specified, shows detailed help for that command."
        echo ""
        echo "Examples:"
        echo "  pai help           Display general help"
        echo "  pai help init      Display help for the 'init' command"
        echo "  pai help prompts   Display help for the 'prompts' command"
        ;;
      *)
        pai_error "Unknown command: $command"
        echo ""
        pai_help
        return 1
        ;;
    esac
    
    echo ""
    echo "For more information, visit: https://github.com/bachlee89/pai-tool"
    return 0
  fi
  
  # General help
  echo "╔═════════════════════════════════════════════════╗"
  echo "║            PAI Tool - AI Tooling               ║"
  echo "║          by Bach Le with ❤️ (v$PAI_VERSION)          ║"
  echo "╚═════════════════════════════════════════════════╝"
  echo ""
  echo "Usage: pai <command> [options]"
  echo ""
  echo "Commands:"
  echo "  init [template]    Initialize a new project with templates"
  echo "  prompts            Create AI prompt templates for your project"
  echo "  plan               Create project planning document templates"
  echo "  mcp <tool> [action] Manage MCP tools for Cursor IDE"
  echo "  version [-c]       Display current version and check for updates"
  echo "  upgrade            Update PAI to the latest version"
  echo "  uninstall          Remove PAI Tool from your system"
  echo "  help [command]     Display help for a specific command"
  echo ""
  echo "Examples:"
  echo "  pai init cursor    Initialize with Cursor IDE templates"
  echo "  pai init windsurf  Initialize with Windsurf DevOps rules"
  echo "  pai prompts        Create AI prompts template in current directory"
  echo "  pai plan           Create project planning documents"
  echo "  pai mcp bs start   Start Browser MCP Server"
  echo "  pai version -c     Display version and check for updates"
  echo "  pai help init      Show detailed help for 'init' command"
  echo ""
  echo "For detailed documentation on any command, use:"
  echo "  pai help <command>"
  echo ""
  echo "For more information, visit: https://github.com/bachlee89/pai-tool"
}

# Command: pai init
pai_init() {
  local template="$1"
  local current_dir="$(pwd)"
  
  pai_info "Initializing project with template: $template"
  
  case "$template" in
    cursor)
      # Create .cursor/rules directory if it doesn't exist
      pai_ensure_dir "$current_dir/.cursor/rules" || {
        pai_error "Failed to create .cursor/rules directory"
        return 1
      }
      
      # Copy rules from examples with .mdc.sample suffix
      local source_dir="$PAI_DIR/examples/rules/cursor"
      local target_dir="$current_dir/.cursor/rules"
      
      pai_info "Copying Cursor rules templates..."
      
      # Get all .mdc files from the examples directory
      for source_file in "$source_dir"/*.mdc; do
        if [ -f "$source_file" ]; then
          local filename=$(basename "$source_file")
          local target_file="$target_dir/${filename}.sample"
          
          # Copy the file with .sample suffix
          cp "$source_file" "$target_file" || {
            pai_error "Failed to copy $filename to $target_file"
            continue
          }
          
          pai_info "Created $target_file"
        fi
      done
      
      # Copy mcp.json.sample file
      local mcp_source="$PAI_DIR/examples/mcp/mcp.json"
      local mcp_target="$current_dir/.cursor/mcp.json.sample"
      
      if [ -f "$mcp_source" ]; then
        pai_info "Copying MCP configuration template..."
        cp "$mcp_source" "$mcp_target" || {
          pai_error "Failed to copy MCP configuration template"
        }
        
        if [ -f "$mcp_target" ]; then
          pai_info "Created $mcp_target"
        fi
      else
        pai_error "MCP configuration template not found at $mcp_source"
      fi
      
      # Copy .cursor.json.sample file
      local cursor_json_source="$PAI_DIR/examples/rules/cursor/.cursor.json"
      local cursor_json_target="$current_dir/.cursor.json.sample"
      
      if [ -f "$cursor_json_source" ]; then
        pai_info "Copying Cursor JSON configuration template..."
        cp "$cursor_json_source" "$cursor_json_target" || {
          pai_error "Failed to copy Cursor JSON configuration template"
        }
        
        if [ -f "$cursor_json_target" ]; then
          pai_info "Created $cursor_json_target"
        fi
      else
        pai_error "Cursor JSON configuration template not found at $cursor_json_source"
      fi
      
      pai_info "Cursor initialization complete!"
      pai_info "Rename the .sample files to use them as configuration."
      ;;
    
    windsurf)
      pai_info "Setting up Windsurf DevOps rules template..."
      
      # Copy the .windsurfrules file with .sample suffix
      local windsurf_source="$PAI_DIR/examples/rules/windsurf/.windsurfrules"
      local windsurf_target="$current_dir/.windsurfrules.sample"
      
      if [ -f "$windsurf_source" ]; then
        cp "$windsurf_source" "$windsurf_target" || {
          pai_error "Failed to copy Windsurf rules template"
          return 1
        }
        
        if [ -f "$windsurf_target" ]; then
          pai_info "Created $windsurf_target"
        else
          pai_error "Failed to create windsurf rules template"
          return 1
        fi
      else
        pai_error "Windsurf rules template not found at $windsurf_source"
        return 1
      fi
      
      # Copy mcp_config.json.sample file to the correct Windsurf MCP directory
      local mcp_source="$PAI_DIR/examples/mcp/mcp.json"
      local windsurf_mcp_dir="$HOME/.codeium/windsurf"
      local mcp_target="$windsurf_mcp_dir/mcp_config.json.sample"
      
      # Create Windsurf MCP directory if it doesn't exist
      pai_ensure_dir "$windsurf_mcp_dir" || {
        pai_error "Failed to create Windsurf MCP directory at $windsurf_mcp_dir"
      }
      
      if [ -f "$mcp_source" ]; then
        pai_info "Copying MCP configuration template to Windsurf directory..."
        cp "$mcp_source" "$mcp_target" || {
          pai_error "Failed to copy MCP configuration template"
        }
        
        if [ -f "$mcp_target" ]; then
          pai_info "Created $mcp_target"
        else
          pai_warn "Failed to create MCP configuration template"
        fi
      else
        pai_error "MCP configuration template not found at $mcp_source"
      fi
      
      pai_info "Windsurf initialization complete!"
      pai_info "Rename .windsurfrules.sample to .windsurfrules to activate the template."
      pai_info "Rename $windsurf_mcp_dir/mcp_config.json.sample to $windsurf_mcp_dir/mcp_config.json to use MCP configuration."
      ;;
    
    *)
      pai_error "Unknown template: $template"
      pai_info "Available templates: cursor, windsurf"
      return 1
      ;;
  esac
  
  return 0
}

# Command: pai prompts
pai_prompts() {
  local source_file="$PAI_DIR/examples/prompts/TEMPLATES.md"
  local target_file="$(pwd)/PROMPTS.md"
  
  if [ -f "$source_file" ]; then
    pai_info "Copying prompts template to current project..."
    
    # Check if target file already exists
    if [ -f "$target_file" ]; then
      pai_warn "PROMPTS.md already exists in the current directory."
      pai_info "Do you want to overwrite it? (y/n)"
      read -r answer
      
      if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
        pai_info "Operation cancelled."
        return 0
      fi
    fi
    
    # Copy the file
    cp "$source_file" "$target_file" || {
      pai_error "Failed to copy prompts template"
      return 1
    }
    
    pai_info "PROMPTS.md has been created in the current directory."
    pai_info "You can now customize it for your project needs."
  else
    pai_error "Templates file not found"
    return 1
  fi
  
  return 0
}

# Command: pai plan
pai_plan() {
  local current_dir="$(pwd)"
  local planning_dir="$current_dir/docs/planning"
  
  pai_info "Setting up project planning documents..."
  
  # Create the planning directory if it doesn't exist
  pai_ensure_dir "$planning_dir" || {
    pai_error "Failed to create docs/planning directory structure"
    return 1
  }
  
  pai_info "Created planning directory: $planning_dir"
  
  # Copy planning document templates
  local source_dir="$PAI_DIR/examples/docs/planning"
  local templates=("ROADMAP.md" "TASK.md" "DESIGN.md")
  local success_count=0
  
  for template in "${templates[@]}"; do
    local source_file="$source_dir/$template"
    local target_file="$planning_dir/${template}.sample"
    
    if [ -f "$source_file" ]; then
      # Check if target file already exists
      if [ -f "$target_file" ]; then
        pai_warn "$template.sample already exists in the planning directory"
        pai_info "Do you want to overwrite it? (y/n)"
        read -r answer
        
        if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
          pai_info "Skipping $template"
          continue
        fi
      fi
      
      cp "$source_file" "$target_file" || {
        pai_error "Failed to copy $template template"
        continue
      }
      
      if [ -f "$target_file" ]; then
        pai_info "Created $target_file"
        ((success_count++))
      else
        pai_error "Failed to create $template template"
      fi
    else
      pai_error "$template template not found at $source_file"
    fi
  done
  
  if [ $success_count -eq ${#templates[@]} ]; then
    pai_info "Project planning setup completed successfully!"
  elif [ $success_count -gt 0 ]; then
    pai_warn "Project planning setup completed with some warnings."
  else
    pai_error "Project planning setup failed."
    return 1
  fi
  
  pai_info "Rename the .sample files to use them for your project planning."
  
  return 0
}

# Command: pai mcp
pai_mcp() {
  local tool="$1"
  shift
  
  if [ -z "$tool" ]; then
    pai_error "No MCP tool specified"
    pai_info "Run 'pai help mcp' for available MCP tools"
    return 1
  fi
  
  case "$tool" in
    browser-server|bs)
      # Check if MCP module is loaded
      if ! command -v pai_mcp_browser_server >/dev/null 2>&1; then
        pai_error "MCP module not found"
        return 1
      fi
      
      # Pass all remaining arguments to the browser-server function
      pai_mcp_browser_server "$@"
      ;;
    *)
      pai_error "Unknown MCP tool: $tool"
      pai_info "Available MCP tools: browser-server (bs)"
      return 1
      ;;
  esac
  
  return 0
}

# Command: pai version
pai_version() {
  local current_version="$PAI_VERSION"
  local check_update=false
  
  # Process arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --check-update|-c)
        check_update=true
        shift
        ;;
      *)
        pai_error "Unknown option: $1"
        return 1
        ;;
    esac
  done
  
  # Create a nicely formatted version display
  echo "╔════════════════════════════════════════╗"
  echo "║             PAI Tool Info              ║"
  echo "╠════════════════════════════════════════╣"
  echo "║ Version:      $current_version" | awk '{printf "%-36s\n", $0}' | sed 's/$/║/'
  echo "║ Install Path: $PAI_DIR" | awk '{printf "%-36s\n", $0}' | sed 's/$/║/'
  echo "║ Last Updated: $(date -r "$PAI_DIR/pai.sh" "+%Y-%m-%d %H:%M:%S")" | awk '{printf "%-36s\n", $0}' | sed 's/$/║/'
  echo "╚════════════════════════════════════════╝"
  
  # Check for updates if requested
  if $check_update; then
    echo ""
    echo "Checking for updates..."
    
    if pai_check_version; then
      pai_info "You are using the latest version ($current_version)."
    else
      pai_info "A new version is available."
      pai_info "Run 'pai upgrade' to update to the latest version."
    fi
  else
    echo ""
    echo "To check for updates, run 'pai version --check-update'"
  fi
  
  return 0
}

# Command: pai upgrade
pai_upgrade() {
  pai_info "Checking for updates..."
  
  # Create a timestamp for backup
  local timestamp=$(date +"%Y%m%d%H%M%S")
  local backup_dir="$PAI_DIR/backups/$timestamp"
  local current_version="$PAI_VERSION"
  local latest_version
  local repo_url="https://github.com/bachlee89/pai-tool.git"
  local temp_dir="$PAI_DIR/temp_upgrade"
  
  # Check if we're running the latest version
  if pai_check_version; then
    pai_info "You are already running the latest version ($current_version)."
    return 0
  fi
  
  # Create backup directory
  pai_ensure_dir "$PAI_DIR/backups" || {
    pai_error "Failed to create backup directory"
    return 1
  }
  
  pai_ensure_dir "$backup_dir" || {
    pai_error "Failed to create backup directory for this upgrade"
    return 1
  }
  
  pai_info "Creating backup of current installation to $backup_dir"
  
  # Copy current files to backup directory (excluding backups and temp dirs)
  rsync -a --exclude="backups" --exclude="temp_*" "$PAI_DIR/" "$backup_dir/" || {
    pai_error "Failed to create backup. Upgrade aborted."
    return 1
  }
  
  pai_info "Backup created successfully"
  
  # Clean any existing temp directory
  if [ -d "$temp_dir" ]; then
    rm -rf "$temp_dir"
  fi
  
  # Create temp directory for download
  pai_ensure_dir "$temp_dir" || {
    pai_error "Failed to create temporary directory for upgrade"
    return 1
  }
  
  pai_info "Downloading latest version..."
  
  # Clone the repository to temp directory
  if ! git clone "$repo_url" "$temp_dir" --depth 1; then
    pai_error "Failed to download the latest version"
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Get the version from the new download
  local new_version
  if [ -f "$temp_dir/pai.sh" ]; then
    # Extract version from the downloaded pai.sh
    new_version=$(grep "PAI_VERSION=" "$temp_dir/pai.sh" | cut -d'"' -f2)
    pai_info "Downloaded version: $new_version"
  else
    pai_error "Downloaded package is invalid (pai.sh not found)"
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Update the installation (exclude .git, backups, and temp dirs)
  pai_info "Installing update..."
  rsync -a --exclude=".git" --exclude="backups" --exclude="temp_*" "$temp_dir/" "$PAI_DIR/" || {
    pai_error "Failed to install update. Attempting rollback..."
    
    # Rollback to backup
    if rsync -a "$backup_dir/" "$PAI_DIR/" --exclude="backups"; then
      pai_info "Rollback successful"
    else
      pai_error "Rollback failed. Your installation may be in an inconsistent state."
      pai_error "Manual restore from backup at $backup_dir may be required."
    fi
    
    rm -rf "$temp_dir"
    return 1
  }
  
  # Clean up temp directory
  rm -rf "$temp_dir"
  
  pai_info "Update completed successfully!"
  pai_info "Previous version: $current_version"
  pai_info "Current version: $new_version"
  pai_info "Backup stored at: $backup_dir"
  
  return 0
}

# Command: pai uninstall
pai_uninstall() {
  pai_info "Uninstalling PAI Tool..."
  
  # Prompt for confirmation
  echo ""
  echo "⚠️  Warning: This will completely remove PAI Tool from your system!"
  echo "This includes:"
  echo "  - The PAI Tool directory at $PAI_DIR"
  echo "  - Symlinks to pai in ~/bin"
  echo "  - Configuration entries in your shell profiles"
  echo ""
  echo "Are you absolutely sure you want to proceed? (yes/no)"
  
  read -r confirmation
  
  if [ "$confirmation" != "yes" ]; then
    pai_info "Uninstallation cancelled."
    return 0
  fi
  
  local success=true
  local profiles=("${HOME}/.bashrc" "${HOME}/.zshrc" "${HOME}/.profile")
  local bin_symlink="${HOME}/bin/pai"
  
  # Step 1: Remove symlink
  if [ -L "$bin_symlink" ]; then
    pai_info "Removing symbolic link at $bin_symlink..."
    
    if rm "$bin_symlink"; then
      pai_info "Symlink removed successfully."
    else
      pai_error "Failed to remove symlink at $bin_symlink."
      success=false
    fi
  else
    pai_info "No symlink found at $bin_symlink."
  fi
  
  # Step 2: Clean up shell configuration files
  pai_info "Cleaning up shell configuration files..."
  
  for profile in "${profiles[@]}"; do
    if [ -f "$profile" ]; then
      pai_info "Checking $profile..."
      
      # Create a temporary file
      local tmp_file="$(mktemp)"
      
      # Filter out PAI-related lines
      grep -v "# PAI Tool" "$profile" | grep -v "export PATH.*\.pai" | grep -v "source.*\.pai/pai.sh" > "$tmp_file"
      
      # Replace original file with cleaned version
      mv "$tmp_file" "$profile"
      
      pai_info "Cleaned $profile."
    fi
  done
  
  # Step 3: Remove PAI directory
  if [ -d "$PAI_DIR" ]; then
    pai_info "Removing PAI Tool directory at $PAI_DIR..."
    
    if rm -rf "$PAI_DIR"; then
      pai_info "PAI Tool directory removed successfully."
    else
      pai_error "Failed to remove PAI Tool directory at $PAI_DIR."
      success=false
    fi
  else
    pai_warn "PAI Tool directory not found at $PAI_DIR."
  fi
  
  # Final status
  if $success; then
    echo ""
    echo "╔════════════════════════════════════════════════╗"
    echo "║       PAI Tool has been uninstalled            ║"
    echo "║                                                ║"
    echo "║ Thank you for using PAI Tool!                  ║"
    echo "║ To reinstall in the future, run:               ║"
    echo "║ curl -sSL https://raw.githubusercontent.com/   ║"
    echo "║ bachlee89/pai-tool/main/install.sh | bash      ║"
    echo "╚════════════════════════════════════════════════╝"
  else
    pai_error "Uninstallation completed with errors."
    pai_error "Please check the logs above for details."
    return 1
  fi
  
  return 0
}

# Main function to parse commands
pai_main() {
  # Parse command line arguments
  if [ $# -eq 0 ]; then
    pai_help
    # Use return when sourced, exit when executed directly
    if [ $sourced -eq 1 ]; then
      return 0
    else
      exit 0
    fi
  fi

  # Process commands
  case "$1" in
    init)
      shift
      pai_init "$@"
      ;;
    prompts)
      pai_prompts
      ;;
    plan)
      pai_plan
      ;;
    mcp)
      shift
      pai_mcp "$@"
      ;;
    version)
      shift
      pai_version "$@"
      ;;
    upgrade)
      pai_upgrade
      ;;
    uninstall)
      pai_uninstall
      ;;
    help)
      shift
      pai_help "$@"
      ;;
    *)
      echo "Error: Unknown command '$1'"
      pai_help
      # Use return when sourced, exit when executed directly
      if [ $sourced -eq 1 ]; then
        return 1
      else
        exit 1
      fi
      ;;
  esac

  # Use return when sourced, exit when executed directly
  if [ $sourced -eq 1 ]; then
    return 0
  else
    exit 0
  fi
}

# Only run the main function if the script is executed, not sourced
if [ $sourced -eq 0 ]; then
  pai_main "$@"
fi
