require "test_helper"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Capybara.register_driver(:headless_chrome) do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      # This makes logs available, but doesn't cause them to appear
      # in real time on the console
      loggingPrefs: {
        browser: "ALL",
        client: "ALL",
        driver: "ALL",
        server: "ALL"
      }
    )

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("window-size=1400,1200")
    options.add_argument("headless")
    options.add_argument("disable-gpu")

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities,
      options: options
    )
  end

  driven_by :headless_chrome
  # Only show the path of the screenshot on failed test cases.
  ENV["RAILS_SYSTEM_TESTING_SCREENSHOT"] = "simple"
end
