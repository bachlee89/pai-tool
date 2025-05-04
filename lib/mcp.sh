#!/usr/bin/env bash
# PAI Tool - MCP Tools Module

# Browser MCP Server setup and management
pai_mcp_browser_server() {
  local action="${1:-setup}"
  local current_dir="$(pwd)"
  
  # Check if Node.js and npm are installed
  if ! pai_check_node; then
    pai_error "Node.js is required for MCP browser-server setup."
    pai_info "Please install Node.js from https://nodejs.org/"
    return 1
  fi
  
  case "$action" in
    setup|install)
      pai_info "Setting up Browser MCP Server..."
      
      # Ensure .cursor directory exists
      pai_ensure_dir "$current_dir/.cursor" || {
        pai_error "Failed to create .cursor directory"
        return 1
      }
      
      # Create or update mcp.json configuration
      local mcp_file="$current_dir/.cursor/mcp.json"
      
      if [ -f "$mcp_file" ]; then
        pai_warn "mcp.json already exists at $mcp_file"
        pai_info "Do you want to update it with browser-tools configuration? (y/n)"
        read -r answer
        
        if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
          pai_info "Operation cancelled."
          return 0
        fi
      fi
      
      # Copy the browser-server MCP configuration
      cp "$PAI_DIR/examples/mcp/browser-server-mcp.json" "$mcp_file" || {
        pai_error "Failed to copy browser-server MCP configuration"
        return 1
      }
      
      pai_info "Browser MCP configuration created at $mcp_file"
      
      # Install browser-tools-server package
      if pai_npm_check_installed "@agentdeskai/browser-tools-server"; then
        pai_info "@agentdeskai/browser-tools-server is already installed"
      else
        pai_info "Installing @agentdeskai/browser-tools-server..."
        if ! npm install -g @agentdeskai/browser-tools-server; then
          pai_warn "Failed to install @agentdeskai/browser-tools-server globally"
          pai_info "Will use npx to run it instead"
        fi
      fi
      
      # Check if browser tools MCP is installed
      if pai_npm_check_installed "@agentdeskai/browser-tools-mcp"; then
        pai_info "@agentdeskai/browser-tools-mcp is already installed"
      else
        pai_info "Installing @agentdeskai/browser-tools-mcp..."
        if ! npm install -g @agentdeskai/browser-tools-mcp; then
          pai_warn "Failed to install @agentdeskai/browser-tools-mcp globally"
          pai_info "Will use npx to run it as configured in mcp.json"
        fi
      fi
      
      pai_info "Browser MCP Server setup completed."
      pai_info "To start the browser-tools-server, run: pai mcp browser-server start"
      
      # Provide Chrome extension installation guidance
      pai_info "--------------------------------------------------------------"
      pai_info "Don't forget to install the Chrome extension:"
      pai_info "1. Download from: https://github.com/AgentDeskAI/browser-tools-mcp/releases"
      pai_info "2. Look for the latest release and download BrowserTools-*-extension.zip"
      pai_info "3. Unzip and load as an unpacked extension in Chrome developer mode"
      pai_info "--------------------------------------------------------------"
      ;;
      
    start)
      pai_info "Starting Browser Tools Server..."
      
      # Check if browser-tools-server is already running
      if pgrep -f "@agentdeskai/browser-tools-server" > /dev/null; then
        pai_info "Browser-tools-server is already running"
      else
        # Start the browser-tools-server
        if pai_command_exists npx; then
          pai_info "Starting browser-tools-server with npx..."
          npx @agentdeskai/browser-tools-server &
          local server_pid=$!
          
          if [ $? -eq 0 ]; then
            pai_info "Browser-tools-server started with PID $server_pid"
            pai_info "Server running at http://localhost:3000"
          else
            pai_error "Failed to start browser-tools-server"
            return 1
          fi
        else
          pai_error "npx not found. Make sure Node.js and npm are properly installed."
          return 1
        fi
      fi
      
      # Inform about Cursor MCP configuration
      pai_info "--------------------------------------------------------------"
      pai_info "Make sure to enable the MCP in Cursor:"
      pai_info "1. In Cursor, go to 'Cursor -> Settings -> Cursor Settings'"
      pai_info "2. Select the 'MCP' tab"
      pai_info "3. Enable the browser-tools MCP server"
      pai_info "4. Restart Cursor if needed"
      pai_info "--------------------------------------------------------------"
      ;;
      
    stop)
      pai_info "Stopping Browser Tools Server..."
      
      # Find and kill browser-tools-server processes
      local server_pids=$(pgrep -f "@agentdeskai/browser-tools-server")
      
      if [ -z "$server_pids" ]; then
        pai_info "No browser-tools-server processes found running"
      else
        for pid in $server_pids; do
          pai_info "Killing browser-tools-server process with PID $pid"
          kill $pid
          
          if [ $? -eq 0 ]; then
            pai_info "Process $pid stopped successfully"
          else
            pai_warn "Failed to stop process $pid"
          fi
        done
      fi
      ;;
      
    status)
      # Check if browser-tools-server is running
      local server_pids=$(pgrep -f "@agentdeskai/browser-tools-server")
      
      if [ -z "$server_pids" ]; then
        pai_info "Browser-tools-server is not running"
      else
        pai_info "Browser-tools-server is running with PIDs: $server_pids"
        pai_info "Server should be available at http://localhost:3000"
      fi
      
      # Check MCP configuration
      local mcp_file="$current_dir/.cursor/mcp.json"
      
      if [ -f "$mcp_file" ]; then
        if grep -q "browser-tools" "$mcp_file"; then
          pai_info "MCP configuration found with browser-tools settings"
        else
          pai_warn "MCP configuration exists but does not contain browser-tools settings"
        fi
      else
        pai_warn "No MCP configuration found at $mcp_file"
      fi
      ;;
      
    *)
      pai_error "Unknown action: $action"
      pai_info "Available actions: setup, start, stop, status"
      return 1
      ;;
  esac
  
  return 0
} 