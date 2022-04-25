require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WebMock.allow_net_connect!
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w(--auto-open-devtools-for-tabs --window-size=1600,1000)
  )

  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new( app, browser: :chrome, capabilities: options )
  end

  driven_by :selenium_chrome, using: :chrome

end
