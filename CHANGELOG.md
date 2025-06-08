# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Test Structure**: Updated test helper file structure for better separation of concerns
  - Moved configuration tests to `spec/unit/configuration_spec.rb`
  - Updated `spec_helper.rb` for pure Ruby logic tests only
  - Deprecated main `spec/rails_helper.rb` with automatic redirection to appropriate helpers
  - Rails-based tests now use `spec/rails_demo/spec/rails_helper.rb`
- **Configuration**: Fixed duplicate `disable_authentication` method in Configuration class

### Fixed
- Removed duplicate method definitions in `StompBase::Configuration`
- Updated test helper references for consistency

## [0.2.0] - 2025-05-28

### Added
- **View Components**: Migrated to ViewComponent for modular, testable UI components
- **Lookbook Integration**: Component development and documentation platform
- **Enhanced Console**: Improved security with command validation and timeout protection
- **Stimulus Controllers**: Modern JavaScript interactions replacing React
- **Component Tests**: Comprehensive test suite for View Components
- **Component Previews**: Lookbook previews for all major components

### Changed
- **BREAKING**: Replaced React frontend with View Components and Stimulus
- **BREAKING**: Updated styling from custom CSS to standard CSS
- **Improved**: Enhanced security for console command execution
- **Improved**: Better responsive design
- **Improved**: Modular architecture with reusable components

### Removed
- **BREAKING**: React, TypeScript, and Webpack dependencies
- **BREAKING**: Frontend build process and Node.js dependencies
- Legacy CSS styles

### Migration Guide
- Remove React/frontend dependencies from your application
- View Components are now used for all UI rendering
- Access component development at `/rails/lookbook` in development

## [0.1.0] - 2025-05-27

### Added
- Initial implementation of StompBase Rails engine
- Browser-based admin dashboard with real-time Rails application statistics
- Browser console for executing Ruby code in Rails environment
- Multi-language support (English/Japanese)
- Built-in authentication features:
  - Basic Authentication (username/password)
  - API Key Authentication (header or parameter)
  - Custom Authentication (custom logic)
- React-based frontend with TypeScript support
- Modern, responsive UI design
- Easy integration with simple gem installation and mounting process
- Comprehensive test suite with RSpec
- Sample configuration files and documentation

### Features
- 📊 Dashboard: Real-time Rails application statistics and system information
- 💻 Browser Console: Execute Ruby code directly in your Rails environment
- 🎨 Modern UI: Clean, responsive interface
- 🌐 Multi-language Support: English and Japanese interface
- 🔧 Easy Integration: Simple gem installation and mounting process
- 🔐 Built-in Authentication: Simple authentication options (Basic Auth, API keys, Custom)

[0.2.0]: https://github.com/snowwshiro/stomp_base/releases/tag/v0.2.0
[0.1.0]: https://github.com/snowwshiro/stomp_base/releases/tag/v0.1.0
