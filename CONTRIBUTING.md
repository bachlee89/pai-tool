# Contributing to PAI Tool

Thank you for considering contributing to PAI Tool! This document provides guidelines and instructions for contributing to this project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for PAI Tool.

- **Use a clear and descriptive title** for the issue
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** if possible
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see and why**
- **Include details about your environment** (OS, shell version, etc.)

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for PAI Tool.

- **Use a clear and descriptive title** for the issue
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps** if applicable
- **Describe the current behavior and explain the behavior you expected to see**
- **Explain why this enhancement would be useful to most PAI Tool users**

### Pull Requests

- **Fill in the required template**
- **Do not include issue numbers in the PR title**
- **Follow the shell scripting style guide**
- **Include screenshots and animated GIFs if relevant**
- **Document new code**
- **Run the test suite**
- **End all files with a newline**

## Style Guides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable prefix:
  - `feat:` - A new feature
  - `fix:` - A bug fix
  - `docs:` - Documentation only changes
  - `style:` - Changes that do not affect the meaning of the code
  - `refactor:` - A code change that neither fixes a bug nor adds a feature
  - `perf:` - A code change that improves performance
  - `test:` - Adding missing tests or correcting existing tests
  - `chore:` - Changes to the build process or auxiliary tools

### Shell Script Styleguide

- Use 2 spaces for indentation
- Use POSIX-compliant syntax where possible
- Include error handling for all commands that might fail
- Use descriptive variable names (lowercase for regular variables, uppercase for constants)
- Document functions with comments
- Use `pai_` prefix for all functions

### Documentation Styleguide

- Use [Markdown](https://guides.github.com/features/mastering-markdown/)
- Reference examples wherever possible
- Keep explanations clear and concise
- Include command examples for features

## Development Process

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork locally
3. Set up the development environment

```bash
git clone https://github.com/bachlee89/pai-tool.git
cd pai-tool
# Link your local version for testing
ln -sf "$(pwd)/pai.sh" ~/bin/pai
```

### Testing Your Changes

Before submitting a PR, make sure to test your changes:

```bash
# Test the basic commands
pai version
pai help
pai init cursor

# If you've added a new command, test it thoroughly
```

### Submitting a Pull Request

1. Push your changes to your fork
2. Submit a pull request from your fork to the main repository
3. Address any feedback from maintainers

## Project Structure

Understanding the project structure helps you make effective contributions:

```
pai-tool/
├── pai.sh             # Main script file
├── install.sh         # Installation script
├── lib/               # Helper functions and modules
│   └── utils.sh       # Utility functions
├── docs/              # Documentation
│   └── planning/      # Project planning documents
├── examples/          # Example files and templates
│   ├── prompts/       # AI prompt templates
│   └── rules/         # AI assistant rules
```

## Additional Resources

- [Project ROADMAP](docs/planning/ROADMAP.md)
- [Project DESIGN](docs/planning/DESIGN.md)

## Thank You!

Thank you for contributing to PAI Tool!
