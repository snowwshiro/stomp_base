# frozen_string_literal: true

# ⚠️  DEPRECATED: This file is deprecated
#
# For Rails-based tests (views, controllers, integration):
#   Use: spec/rails_demo/spec/rails_helper.rb
#
# For pure Ruby logic tests (unit tests, configuration):
#   Use: spec_helper.rb
#
# This file will be removed in a future version.

puts <<~WARNING
  ⚠️  WARNING: You are using the deprecated rails_helper.rb

  For Rails-based tests, use: spec/rails_demo/spec/rails_helper.rb
  For pure Ruby logic tests, use: spec_helper.rb

  This file will be removed in a future version.
WARNING

# Automatic redirection based on test location
if caller.any? { |line| line.include?("/spec/rails_demo/") }
  require_relative "rails_demo/spec/rails_helper"
else
  require_relative "spec_helper"
end
