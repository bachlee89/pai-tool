# PAI Tool Change Log

All notable changes to the PAI Tool will be documented in this file.

## [0.1.1] - 2025-05-21

### Added
- New command: `pai statistics` to analyze project code statistics
  - Counts total lines of code in the project
  - Identifies and counts AI-generated code lines (using REF-PR-* references)
  - Calculates the percentage of AI-generated code
  - Supports .paiignore file for excluding directories and files

### Fixed
- Improved file handling to prevent "Is a directory" errors
- Fixed arithmetic expression errors when calculating statistics
- Enhanced path handling for files with spaces or special characters
- Added proper error handling for empty or invalid results

### Documentation
- Updated comment.mdc rule with detailed information about reference tags
- Added language-specific examples for inline and block comments
- Added .paiignore.sample file to demonstrate custom ignore patterns

## [0.1.0] - 2025-04-01

### Initial Release
- Basic directory structure setup
- Core command implementation: init, prompts, plan, version, upgrade, uninstall
- MCP tools management with browser-server support
- Documentation and installation script 