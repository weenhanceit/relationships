ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "capybara/rails"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# I found that with Rails 5, IntegrationTest is used for controller tests, too,
# and things get weird if you put the Capybara stuff inside the controller
# tests. So I make a new class for Capybara tests, instead of patching the
# integration test class.
class CapybaraTestCase < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# I got this from: https://github.com/chriskottom/minitest_cookbook_source/issues/3
# To fix transacation issues with Poltergeist tests
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
