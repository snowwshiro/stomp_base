# Release Process Guide

This document outlines the automated release process for the Stomp Base gem using GitHub Flow and Semantic Versioning.

## Overview

Stomp Base uses **GitHub Flow** with automated versioning to provide a seamless development and release experience. Every merge to the `main` branch automatically triggers version bumping, gem publishing, and release creation.

## Semantic Versioning

We follow [Semantic Versioning (SemVer)](https://semver.org/) with the format `MAJOR.MINOR.PATCH`:

- **MAJOR** (`X.0.0`) - Breaking changes that require user action
- **MINOR** (`0.X.0`) - New features that are backwards compatible
- **PATCH** (`0.0.X`) - Bug fixes and small improvements

## Automated Workflow

### 1. Development Process

1. **Create feature branch** from `main`
2. **Make changes** and add tests
3. **Update CHANGELOG.md** in `[Unreleased]` section
4. **Open Pull Request** for review
5. **Merge to main** after approval

### 2. Automatic Version Bumping

When you merge to `main`, the system automatically:

1. **Analyzes commit messages** for version bump hints
2. **Bumps version** (patch by default)
3. **Updates CHANGELOG.md** (moves `[Unreleased]` to new version)
4. **Creates Git tag** with new version
5. **Triggers release workflow**

### 3. Version Bump Control

#### Default Behavior
- **Patch bump** for most merges

#### Manual Control via Commit Messages
Include keywords in your commit messages:

```bash
# Major version bump (breaking changes)
git commit -m "feat: redesigned API with breaking changes [major]"
git commit -m "refactor: breaking change in authentication"

# Minor version bump (new features)
git commit -m "feat: add new dashboard widgets [minor]"
git commit -m "feature: enhanced console with autocomplete"

# Patch version bump (default)
git commit -m "fix: resolve memory leak in dashboard"
git commit -m "docs: update installation guide"
```

#### Manual Trigger
Use GitHub Actions workflow dispatch:
1. Go to **Actions** → **Version Bump**
2. Click **Run workflow**
3. Select version type (major/minor/patch)

## CHANGELOG Management

### Adding Changes

Always update the `[Unreleased]` section in `CHANGELOG.md`:

```markdown
## [Unreleased]

### Added
- New feature descriptions

### Changed  
- Modified behavior descriptions

### Fixed
- Bug fix descriptions

### Removed
- Deprecated feature removals
```

### Automatic Processing

The version bump workflow automatically:
1. **Moves content** from `[Unreleased]` to new version section
2. **Adds release date** to the new version
3. **Creates empty `[Unreleased]`** section for future changes
4. **Updates version links** at bottom of file

## Release Workflow

After version bumping, the release workflow automatically:

1. **Runs full test suite** on the new tag
2. **Builds gem** (`stomp_base-X.Y.Z.gem`)
3. **Creates GitHub Release** with auto-generated notes
4. **Publishes to RubyGems.org** (requires `RUBYGEMS_API_KEY` secret)
5. **Uploads gem artifact** to the release

## Branch Protection

### Recommended Settings

For `main` branch in GitHub repository settings:

- ✅ **Require a pull request before merging**
- ✅ **Require approvals** (at least 1)
- ✅ **Dismiss stale PR approvals when new commits are pushed**
- ✅ **Require status checks to pass before merging**
  - `test (3.4, 8.0)` - Test suite
  - `Code Quality - rubocop` - Style checks
  - `Code Quality - bundle-audit` - Security audit
  - `security` - Brakeman security scan
- ✅ **Require branches to be up to date before merging**
- ✅ **Require linear history** (optional, for clean history)

## Environment Setup

### Required Secrets

In GitHub repository settings → Secrets:

- `RUBYGEMS_API_KEY` - API key for publishing to RubyGems.org

### Ruby Gems Configuration

In `stomp_base.gemspec`:
```ruby
spec.metadata["rubygems_mfa_required"] = "true"
```

Ensures MFA is required for gem publishing security.

## Development Commands

### Version Management

```bash
# Check current version
ruby -r ./lib/stomp_base/version.rb -e 'puts StompBase::VERSION'

# Test version bump (dry run)
./bin/version_bump --dry-run patch
./bin/version_bump --dry-run minor  
./bin/version_bump --dry-run major

# Manual version bump (local development only)
./bin/version_bump patch
```

### Testing

```bash
# Run unit tests
bundle exec rspec spec/lib spec/unit

# Run Rails/UI tests  
cd spec/rails_demo && bundle exec rspec

# Run code quality checks
bundle exec rubocop
bundle exec reek lib/
bundle exec brakeman
```

### Gem Management

```bash
# Build gem locally
gem build stomp_base.gemspec

# Install local version
gem install ./stomp_base-X.Y.Z.gem
```

## Troubleshooting

### Version Bump Issues

**Problem:** Version bump workflow doesn't trigger
- **Check:** Commit message doesn't contain `[version bump]` (prevents loops)
- **Check:** Push is to `main` branch
- **Solution:** Manually trigger via GitHub Actions

**Problem:** CHANGELOG not updated
- **Check:** `[Unreleased]` section has content
- **Check:** Proper markdown formatting
- **Solution:** Add content to `[Unreleased]` and re-run

### Release Issues

**Problem:** Gem publish fails
- **Check:** `RUBYGEMS_API_KEY` secret is set
- **Check:** API key has publish permissions
- **Check:** MFA is configured for RubyGems account

**Problem:** Tests fail on tag
- **Check:** All tests pass on main branch
- **Check:** No uncommitted changes during version bump
- **Solution:** Fix tests and manually create new tag

### Manual Recovery

If automation fails, manually create release:

```bash
# 1. Fix any issues locally
# 2. Bump version manually
./bin/version_bump patch

# 3. Commit and tag
git add lib/stomp_base/version.rb CHANGELOG.md
git commit -m "chore: bump version to X.Y.Z [version bump]"
git tag "vX.Y.Z"

# 4. Push changes
git push origin main
git push origin "vX.Y.Z"
```

## Best Practices

### For Contributors

1. **Always update CHANGELOG.md** in PRs
2. **Use descriptive commit messages** with version hints
3. **Test thoroughly** before merging
4. **Keep PRs focused** on single features/fixes

### For Maintainers

1. **Review CHANGELOG updates** in PRs
2. **Ensure proper version bump types** for changes
3. **Monitor automated workflows** for failures
4. **Keep branch protection rules** up to date

## Resources

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
- [GitHub Actions for Ruby](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-ruby)