# Contributing to Stomp Base

Welcome to the Stomp Base project! We appreciate your interest in contributing. This guide will help you understand our development process and how to contribute effectively.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [GitHub Flow Workflow](#github-flow-workflow)
- [Versioning and Releases](#versioning-and-releases)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Testing](#testing)
- [Code Quality](#code-quality)
- [Documentation](#documentation)

## Code of Conduct

By participating in this project, you agree to abide by respectful and inclusive behavior. Please be kind and considerate in all interactions.

## Getting Started

### Prerequisites

- Ruby 3.0 or higher
- Bundler
- Git

### Setup Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/stomp_base.git
   cd stomp_base
   ```

3. **Install dependencies**:
   ```bash
   bundle install
   cd spec/rails_demo
   bundle install
   cd ../..
   ```

4. **Run tests** to ensure everything works:
   ```bash
   # Run unit tests
   bundle exec rspec spec/lib spec/unit
   
   # Run Rails/UI tests
   cd spec/rails_demo
   bundle exec rspec
   ```

5. **Run code quality checks**:
   ```bash
   bundle exec rubocop
   bundle exec reek lib/
   bundle exec brakeman
   ```

## Development Process

We follow **GitHub Flow** for our development process:

1. **Create a feature branch** from `main`
2. **Make your changes** with commits
3. **Open a Pull Request** early for discussion
4. **Collaborate** on the PR with reviews
5. **Merge** to `main` when ready

## GitHub Flow Workflow

### 1. Create a Feature Branch

```bash
# Update main branch
git checkout main
git pull origin main

# Create and switch to feature branch
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- **Write clear, focused commits**
- **Include tests** for new functionality
- **Update documentation** if needed
- **Follow code style** guidelines

### 3. Commit Guidelines

Use clear, descriptive commit messages:

```bash
# Good examples
git commit -m "feat: add authentication middleware"
git commit -m "fix: resolve memory leak in console handler"
git commit -m "docs: update installation instructions"

# For version bumps (use commit message hints):
git commit -m "feat: add new dashboard widgets [minor]"
git commit -m "fix: critical security issue [patch]"
git commit -m "feat: breaking API changes [major]"
```

### 4. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- **Clear title** describing the change
- **Detailed description** of what and why
- **Link to related issues** if applicable
- **Screenshots** for UI changes

## Versioning and Releases

We use **Semantic Versioning (SemVer)** and automated version management:

### Version Bump Types

- **Patch** (`0.0.X`) - Bug fixes, small improvements
- **Minor** (`0.X.0`) - New features, backwards compatible
- **Major** (`X.0.0`) - Breaking changes

### Automatic Version Bumping

Version bumps happen automatically when merging to `main`:

1. **Default:** Patch version bump
2. **Manual control:** Use commit message hints:
   - `[major]` or `breaking change` → Major bump
   - `[minor]` or `feat`/`feature` → Minor bump
   - Default → Patch bump

3. **Manual trigger:** Use GitHub Actions workflow dispatch

### CHANGELOG Updates

- **Add entries** to the `[Unreleased]` section in `CHANGELOG.md`
- **Follow format:**
  ```markdown
  ### Added
  - New feature description
  
  ### Changed
  - Modified behavior description
  
  ### Fixed
  - Bug fix description
  ```

- **Automatic processing:** Version bump workflow moves `[Unreleased]` content to new version section

## Pull Request Guidelines

### Before Submitting

- [ ] Tests pass locally
- [ ] Code follows style guidelines (RuboCop passes)
- [ ] No security issues (Brakeman passes)
- [ ] Documentation updated if needed
- [ ] CHANGELOG.md updated in `[Unreleased]` section

### PR Requirements

- **Focus:** One feature or fix per PR
- **Size:** Keep PRs manageable (< 500 lines preferred)
- **Tests:** Include appropriate test coverage
- **Reviews:** All PRs require review before merging
- **CI:** All status checks must pass

### Review Process

1. **Automated checks** run (CI, tests, code quality)
2. **Reviewer assignment** (maintainers or team members)
3. **Code review** and discussion
4. **Address feedback** with additional commits
5. **Final approval** and merge

## Testing

### Test Structure

We have two types of tests:

#### Unit/Logic Tests (`spec/lib/`, `spec/unit/`)
```bash
bundle exec rspec spec/lib spec/unit
```

For testing:
- Core StompBase logic
- Configuration handling
- Helper methods
- Business logic

#### Rails/UI Tests (`spec/rails_demo/`)
```bash
cd spec/rails_demo
bundle exec rspec
```

For testing:
- ViewComponents
- Controllers
- Integration tests
- UI interactions

### Writing Tests

- **Follow existing patterns** in the test suite
- **Test behavior, not implementation**
- **Use descriptive test names**
- **Include edge cases**
- **Mock external dependencies**

## Code Quality

### Style Guidelines

We use RuboCop for code style enforcement:

```bash
# Check style
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

### Code Analysis

- **Reek** for code smell detection
- **Brakeman** for security analysis
- **Bundle Audit** for dependency security

### Performance

- Keep methods focused and small
- Avoid N+1 queries
- Use appropriate data structures
- Profile when optimizing

## Documentation

### Code Documentation

- **YARD documentation** for public APIs
- **Clear method signatures** and return types
- **Usage examples** for complex functionality

### User Documentation

- **README.md** for main usage instructions
- **CHANGELOG.md** for version history
- **Inline comments** for complex logic

### Generate Documentation

```bash
# Generate YARD documentation
bundle exec yard doc

# Serve documentation locally
bundle exec yard server
```

## Release Process

### Automated Release Flow

1. **Merge PR** to `main` branch
2. **Version bump** happens automatically
3. **Git tag** created automatically
4. **Gem built** and published to RubyGems.org
5. **GitHub Release** created with release notes

### Manual Release (if needed)

```bash
# Bump version manually
./bin/version_bump [major|minor|patch]

# Commit and tag
git add lib/stomp_base/version.rb CHANGELOG.md
git commit -m "chore: bump version to X.Y.Z [version bump]"
git tag "vX.Y.Z"
git push origin main
git push origin "vX.Y.Z"
```

## Getting Help

- **Issues:** Create GitHub issues for bugs or feature requests
- **Discussions:** Use GitHub Discussions for questions
- **Code Review:** Request review from maintainers
- **Documentation:** Check README.md and generated docs

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes for significant contributions
- Project documentation

Thank you for contributing to Stomp Base! 🎛️