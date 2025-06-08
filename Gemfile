# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "bigdecimal" # Ruby 3.4+ compatibility
gem "rails", "~> 7.0" # Improved compatibility with Ruby 3.4 in Rails 7
gem "view_component", "~> 3.0" # ViewComponent for reusable view components

group :development, :test do
  gem "lookbook", "~> 2.0" # Lookbook for component development and documentation
  gem "rspec-rails" # Gem for using RSpec

  # Code quality and linting
  gem "reek", require: false
  gem "rubocop", "~> 1.60", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-rails", "~> 2.23", require: false
  gem "rubocop-rspec", "~> 2.26", require: false

  # Security scanning
  gem "brakeman", require: false
  gem "bundler-audit", require: false

  # Documentation
  gem "redcarpet", require: false
  gem "yard", require: false
end

group :test do
  gem "capybara" # Capybara for testing

  # Test coverage
  gem "simplecov", require: false
  gem "simplecov-lcov", require: false
end
