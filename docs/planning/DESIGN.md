# PAI Tool Structure Document

## Overview
PAI (Project AI) Tool is a shell-based command-line utility designed to streamline project initialization and management workflows. Similar to nvm (Node Version Manager), PAI provides an intuitive CLI interface for managing project resources, configurations, and templates.

## Goals
1. Create a lightweight, POSIX-compliant shell tool that works across Linux distributions
2. Provide a simple interface for initializing projects with standardized templates
3. Enable easy management of project configurations
4. Support self-updating capabilities
5. Maintain comprehensive documentation

## Scope

### In Scope
- Shell-based command-line tool
- Project initialization with templates
- Configuration management
- Self-updating mechanism
- Comprehensive documentation

### Out of Scope (for MVP)
- GUI interface
- Integration with external services (beyond GitHub)
- Advanced plugin architecture (planned for future)
- Cross-platform support beyond POSIX-compliant systems

## Technical Approach

### Implementation
- Primary implementation in Bash/Shell script for maximum compatibility
- Minimal dependencies (curl, git, standard Unix tools)
- Configuration stored in JSON format
- Self-contained installation and updating process

### Directory Structure
```
pai-tool/
├── pai.sh             # Main script file
├── install.sh         # Installation script
├── lib/               # Helper functions and modules
│   └── utils.sh       # Utility functions
├── docs/              # Documentation
│   └── planning/      # Project planning documents
│       ├── ROADMAP.md # Project roadmap and future plans
│       ├── DESIGN.md # Project design document
│       └── TASKS      # Current tasks and progress tracking
├── examples/          # Example files and templates
│   ├── prompts/       # AI prompt templates
│   │   └── TEMPLATES.md # Example prompts for AI assistants
│   └── rules/         # AI assistant rules
│       ├── cursor/    # Rules for Cursor IDE
│       │   └── project.md # Project-specific rules
│       └── windsurf/  # Rules for Windsurf AI
└── .cursor/           # Cursor IDE configuration
    └── rules/         # Cursor IDE rules
        ├── general-rules.mdc # General project rules
        └── devops-rules.mdc  # DevOps specific rules
```

### Installation Method
Similar to nvm, PAI will be installed via a curl or wget command that downloads and executes an installation script:

```bash
curl -o- https://raw.githubusercontent.com/bachlee89/pai-tool/main/install.sh | bash
```

or

```bash
wget -qO- https://raw.githubusercontent.com/bachlee89/pai-tool/main/install.sh | bash
```

The installation script will:
1. Clone or download the repository
2. Set up necessary directories
3. Add PATH and initialization to shell configuration files (.bashrc, .zshrc, etc.)
4. Create initial configuration files

### Command Architecture
Commands will be implemented using a modular approach:
- Main script (pai.sh) parses arguments and dispatches to appropriate handler
- Each command is implemented in a separate function or file
- Common utilities are shared across commands

## Technology Stack
- Bash/Shell scripting
- JSON for configuration files
- Git for version control and updates
- curl/wget for network operations
- Standard Unix tools (sed, awk, grep, etc.)

## Versioning Strategy
- Semantic versioning (MAJOR.MINOR.PATCH)
- Version stored in a dedicated version file
- Version check for update functionality

## Testing Strategy
- Shell script testing with BATS (Bash Automated Testing System)
- Integration tests for key workflows
- Manual testing across different environments

## Documentation Strategy
- README.md for quick start and basic usage
- docs/planning/ROADMAP.md for strategic direction
- docs/planning/DESIGN.md for high-level approach and project structure
- docs/planning/TASK for immediate action items and progress tracking
- examples/prompts/TEMPLATES.md for AI prompt examples and templates
- examples/rules/ directory for AI assistant rules and configurations
  - examples/rules/cursor/ for Cursor IDE specific rules
  - examples/rules/windsurf/ for Windsurf AI specific rules
