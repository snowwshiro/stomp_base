require_relative "lib/stomp_base/version"

Gem::Specification.new do |spec|
  spec.name          = "stomp_base"
  spec.version       = StompBase::VERSION
  spec.authors       = ["snowwshiro"]
  spec.email         = ["snowwshiro@gmail.com"]
  spec.summary       = "A Rails engine providing a browser-based admin interface and console with built-in authentication."
  spec.description   = "Stomp Base is a Ruby gem that integrates a browser-based management dashboard and Rails console into your Rails application, utilizing React for the UI. Features simple authentication options including Basic Auth, API keys, and custom authentication methods."
  spec.homepage      = "https://github.com/snowwshiro/stomp_base"
  spec.license       = "MIT"

  spec.files         = Dir["{app,lib,frontend,config}/**/*", "README.md", "LICENSE", "Rakefile", "CHANGELOG.md"]
  spec.require_paths  = ["lib"]
  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "rails", "~> 7.0"

  spec.metadata["source_code_uri"] = "https://github.com/snowwshiro/stomp_base"
  spec.metadata["changelog_uri"] = "https://github.com/snowwshiro/stomp_base/blob/main/CHANGELOG.md"
end