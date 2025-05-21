# PAI Tool (Project AI Tooling)

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/bachlee89/pai-tool/blob/main/LICENSE)
[![Version](https://img.shields.io/badge/version-0.1.1-green.svg)](https://github.com/bachlee89/pai-tool/releases)

PAI (Project AI Tooling) is a shell-based command-line utility designed to streamline AI-driven project initialization and management workflows. It provides an intuitive CLI interface for managing project resources, configurations, and templates, with a focus on AI assistant integration.

## Features

- 🚀 **Quick Project Initialization** - Set up new projects with best-practice templates
- 🤖 **AI Assistant Integration** - Configure AI assistants (like Cursor IDE) with project-specific rules
- 📝 **Prompt Templates** - Access and customize AI prompt templates for common development tasks
- 🔄 **Self-updating** - Stay current with the latest features and templates
- 💻 **Cross-platform** - Works on any POSIX-compliant system (Linux, macOS)

## Installation

### One-line Installation

```bash
curl -o- https://raw.githubusercontent.com/bachlee89/pai-tool/main/install.sh | bash
```

or using wget:

```bash
wget -qO- https://raw.githubusercontent.com/bachlee89/pai-tool/main/install.sh | bash
```

The installation script will:
1. Clone the repository to ~/.pai
2. Add PAI to your PATH
3. Set up necessary configurations

### Manual Installation

If you prefer a manual installation:

```bash
# Clone the repository
git clone https://github.com/bachlee89/pai-tool.git ~/.pai

# Add to PATH (add this to your .bashrc, .zshrc, or equivalent)
echo 'export PATH="$HOME/.pai:$PATH"' >> ~/.bashrc

# Reload your shell configuration
source ~/.bashrc
```

## Quick Start

### Initialize a New Project with Cursor IDE Templates

```bash
# Create a new project directory
mkdir my-new-project
cd my-new-project

# Initialize with Cursor IDE templates
pai init cursor

# Initialize with Windsurf DevOps rules
pai init windsurf

# Copy .sample files to their active versions
cp .cursor.json.sample .cursor.json
cp .cursor/mcp.json.sample .cursor/mcp.json
cp .cursor/rules/*.sample .cursor/rules/
```

### Add AI Prompt Templates to Your Project

```bash
# Create AI prompt templates in your project
pai prompts
```

### Create Project Planning Documents

```bash
# Set up project planning document templates
pai plan
```

This will create the following templates in the `docs/planning` directory:
- `ROADMAP.md.sample` - Project roadmap and milestones
- `DESIGN.md.sample` - Architecture and design decisions
- `TASK.md.sample` - Task tracking and progress

Simply remove the `.sample` extension to use these templates for your project planning.

### Check for Updates

```bash
# Display version information
pai version

# Check if updates are available
pai version -c

# Update to the latest version
pai upgrade
```

## Commands

PAI provides the following commands:

| Command | Description |
|---------|-------------|
| `pai init [template]` | Initialize a project with specified template |
| `pai prompts` | Create AI prompt templates in current directory |
| `pai version [-c]` | Display version and check for updates |
| `pai upgrade` | Update PAI to the latest version |
| `pai help [command]` | Display help information |

For more detailed information on each command, use:

```bash
pai help [command]
```

## Project Structure

After initializing a project with templates, you'll typically have:

```
my-project/
├── .cursor/              # Cursor IDE configuration directory
│   ├── rules/            # AI assistant rules
│   │   ├── general-rules.mdc  # General project rules
│   │   └── other rule files...
│   └── mcp.json          # Model Context Protocol configuration
├── .cursor.json          # Cursor IDE project configuration
├── PROMPTS.md            # AI prompt templates
└── ... your project files
```

## Contributing

Contributions are welcome! Please see our [Contribution Guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by tools like nvm, rvm, and other version and project managers
- Special thanks to the AI assistant community

---

Made with ❤️ by [Bach Le](https://github.com/bachlee89)

## Overview

PAI Tool is a command-line utility that helps set up and manage project environments with AI tooling integrations. It provides templates, configurations, and utilities for working with various AI-powered development tools.

## Features

- **Project Templates**: Initialize projects with predefined templates
- **Cursor IDE Integration**: Set up Cursor IDE with AI rules and configurations
- **MCP Tool Management**: Manage Model Context Protocol (MCP) tools for Cursor IDE
- **AI Prompts**: Generate templates for AI prompts to use in your project
- **Self-updating**: Built-in update mechanism to stay current with the latest version

## Installation

```bash
# Clone the repository
git clone https://github.com/bachlee89/pai-tool.git

# Navigate to the directory
cd pai-tool

# Run the installation script
./install.sh
```

## Usage

### Initialize a Project

```bash
# Initialize with Cursor IDE templates
pai init cursor

# Initialize with Windsurf DevOps rules
pai init windsurf
```

### Generate AI Prompts Template

```bash
# Create a PROMPTS.md file in your project
pai prompts
```

### Create Project Planning Documents

```bash
# Set up project planning document templates
pai plan
```

This will create the following templates in the `docs/planning` directory:
- `ROADMAP.md.sample` - Project roadmap and milestones
- `DESIGN.md.sample` - Architecture and design decisions
- `TASK.md.sample` - Task tracking and progress

Simply remove the `.sample` extension to use these templates for your project planning.

### Manage MCP Tools for Cursor IDE

```bash
# Set up Browser MCP Server
pai mcp browser-server

# Start Browser MCP Server (short form)
pai mcp bs start

# Stop Browser MCP Server
pai mcp bs stop

# Check status of Browser MCP Server
pai mcp bs status
```

### Check Version

```bash
# Display current version
pai version

# Check for updates
pai version -c
```

### Update PAI Tool

```bash
# Update to the latest version
pai upgrade
```

### Get Help

```bash
# General help
pai help

# Command-specific help
pai help init
pai help mcp
```

## Command: pai mcp browser-server

The `pai mcp browser-server` command (with shortcut `pai mcp bs`) helps set up and manage a Browser MCP Server for Cursor IDE, which enables browser integration with AI models.

### Prerequisites

- Node.js and npm must be installed on your system
- Cursor IDE with MCP support

### Setup

```bash
# Set up Browser MCP Server
pai mcp browser-server

# Or use the shortcut
pai mcp bs
```

This will:
1. Create or update `.cursor/mcp.json` with browser-tools configuration
2. Install required Node.js packages
3. Provide guidance for installing the Chrome extension

### Start the Browser MCP Server

```bash
pai mcp bs start
```

### Stop the Browser MCP Server

```bash
pai mcp bs stop
```

### Check Status

```bash
pai mcp bs status
```

## Documentation

For more detailed documentation, refer to:

- `pai help` - Command-line help
- `docs/` directory - Comprehensive documentation

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Bach Le - Project creator and maintainer
