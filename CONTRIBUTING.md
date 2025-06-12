# Contributing to Stomp Base

Thank you for your interest in contributing to Stomp Base! This guide will help you get started with contributing to the project.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
  - [Local Environment Setup](#local-environment-setup)
  - [Running Tests](#running-tests)
  - [Development Server](#development-server)
- [Making Changes](#making-changes)
- [Types of Contributions](#types-of-contributions)
- [Submitting Changes](#submitting-changes)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Code Review Process](#code-review-process)
- [Code Style](#code-style)
- [Testing](#testing)
- [Reporting Issues](#reporting-issues)
- [Questions and Support](#questions-and-support)
- [Recognition](#recognition)

We welcome contributions to Stomp Base! Here's how you can help:

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/stomp_base.git
   cd stomp_base
   ```
3. **Install dependencies**:
   ```bash
   bundle install
   ```
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Local Environment Setup

1. **Ensure you have the required Ruby version** (see `.ruby-version` or `stomp_base.gemspec`)
2. **Install dependencies**:
   ```bash
   bundle install
   ```

### Running Tests

This project uses a dual testing approach for optimal performance:

#### Pure Ruby Logic Tests
For core StompBase logic that doesn't require Rails:
```bash
bundle exec rspec spec/lib/ spec/unit/
```

#### Rails/UI Tests  
For ViewComponents, controllers, and integration tests:
```bash
cd spec/rails_demo
bundle install
bundle exec rspec spec/
```

#### Run All Tests
```bash
rspec
```

### Development Server

1. **Start the demo application** for testing:
   ```bash
   cd spec/rails_demo
   bundle install
   rails server -p 3001
   ```
   Visit `http://localhost:3001/stomp_base` to see your changes.

2. **Run Lookbook** for component development:
   ```bash
   rails server
   # Visit http://localhost:3001/rails/lookbook
   ```

## Making Changes

1. **Write tests** for your changes in the `spec/` directory
2. **Follow Ruby style guidelines** and ensure your code is properly formatted
3. **Add or update documentation** as needed
4. **Test your changes** thoroughly:
   ```bash
   rspec
   ```

## Types of Contributions

- 🐛 **Bug fixes**: Fix issues or unexpected behavior
- ✨ **New features**: Add new functionality to the engine
- 📚 **Documentation**: Improve or add documentation
- 🎨 **UI/UX improvements**: Enhance the user interface
- 🌐 **Translations**: Add support for new languages
- 🧪 **Tests**: Improve test coverage
- 🔧 **Refactoring**: Improve code quality without changing functionality

## Submitting Changes

1. **Commit your changes** with clear, descriptive messages:
   ```bash
   git add .
   git commit -m "Add: Brief description of your changes"
   ```

2. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub with:
   - Clear title and description
   - Reference to any related issues
   - Screenshots for UI changes
   - Test results confirmation

## Pull Request Guidelines

- **Keep PRs focused**: One feature or fix per PR
- **Write clear descriptions**: Explain what changes you made and why
- **Include tests**: All new code should have appropriate tests
- **Update documentation**: Update README or other docs if needed
- **Follow existing patterns**: Match the existing code style and architecture

## Code Review Process

### Review Timeline
- Initial review typically within 2-3 business days
- Follow-up reviews after changes are made within 1-2 business days
- Reviews prioritize correctness, maintainability, and alignment with project goals

### Review Criteria
- **Functionality**: Does the code work as intended?
- **Tests**: Are there appropriate tests with good coverage?
- **Code Quality**: Is the code readable, maintainable, and following conventions?
- **Documentation**: Are changes properly documented?
- **Breaking Changes**: Are any breaking changes clearly noted and justified?

### After Review
- Address feedback promptly and thoroughly
- Ask questions if feedback is unclear
- Update your branch with any requested changes
- Be open to suggestions and alternative approaches

## Code Style

- Follow Ruby community standards
- Use meaningful variable and method names
- Add comments for complex logic
- Keep methods small and focused
- Use ViewComponent patterns for new UI components

## Testing

### Testing Architecture

This project uses a dual testing approach for optimal performance:

#### Pure Ruby Logic Tests (`spec/lib/` and `spec/unit/`)
- Tests for core StompBase logic that doesn't require Rails
- Configuration tests, helper methods, and business logic
- Use only `spec_helper.rb` - no heavy Rails dependencies
- **Run with**: `bundle exec rspec spec/lib/ spec/unit/`

#### Rails/UI Tests (`spec/rails_demo/`)
- Tests for ViewComponents, controllers, and integration tests
- Run within the rails_demo application environment
- Use `spec/rails_demo/spec/rails_helper.rb`
- **Run with**: `cd spec/rails_demo && bundle exec rspec spec/`

### Test Guidelines
- Write RSpec tests for new functionality
- Ensure all tests pass before submitting
- Include both unit and integration tests where appropriate
- Test edge cases and error conditions
- Follow existing test patterns and naming conventions

### Test Helper Files
- **For pure Ruby logic tests**: Use `spec_helper.rb`
- **For Rails-based tests**: Use `spec/rails_demo/spec/rails_helper.rb`
- The main `spec/rails_helper.rb` is deprecated

## Reporting Issues

Found a bug or have a suggestion? Please:

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear, descriptive title
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Ruby/Rails version information
   - Any relevant error messages

## Questions and Support

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Pull Requests**: For code contributions

## Recognition

Contributors will be acknowledged in:
- GitHub contributors list
- Release notes for significant contributions
- This README (if you make substantial contributions)

Thank you for helping make Stomp Base better! 🙏