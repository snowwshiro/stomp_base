# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2025-06-28

### Added
- **API-only Rails Support**: Automatic compatibility for API-only Rails applications
  - Auto-configure necessary middleware (session, cookies, flash, method override)
  - Automatic session store configuration for API-only applications
  - No manual middleware configuration required in host applications
- **Japanese Documentation**: Complete Japanese translation of README.md (README.ja.md)
- **Rails Demo API**: Complete API-only Rails demonstration application
  - Sample models, migrations, and authentication specifications
  - Proper bin/ directory with Rails binstubs
  - Complete environment configurations

### Changed
- **Settings Controller**: Improved settings save functionality with proper flash message handling
- **Application Controller**: Simplified to use Rails standard flash functionality
- **Routes**: Added POST route support for settings form submission
- **Documentation**: Added cross-language links between README files

### Fixed
- **RuboCop Issues**: Fixed RuboCop execution and code style issues
- **CSS Assets**: Resolved CSS asset loading issues in API-only Rails applications
- **Error Handling**: Improved error handling and logging for middleware setup

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

[0.2.1]: https://github.com/snowwshiro/stomp_base/releases/tag/v0.2.1
[0.2.0]: https://github.com/snowwshiro/stomp_base/releases/tag/v0.2.0
[0.1.0]: https://github.com/snowwshiro/stomp_base/releases/tag/v0.1.0
