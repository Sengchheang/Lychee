require "pp"
require "capybara/rspec"
require "capybara/poltergeist"
require "capybara-screenshot"
require "capybara-screenshot/rspec"
Dir["./support/*.rb"].sort.each {|f| require f}


#
# Driver setup
#

browser = ENV["BROWSER"] || ""
host    = ENV["HOST_URL"] || "photo.web-essentials.asia"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :js_errors => false,
    timeout: 600,
    phantomjs_options: [
      "--ignore-ssl-errors=yes"
    ],
    window_size: [1280, 768]
  )
end

Capybara.default_driver = :poltergeist
Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

# Use Chrome browser (needs to be installed)
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.current_driver = :selenium_chrome if browser.downcase == "chrome"

# Use Firefox (Cabybara's default driver)
Capybara.current_driver = :selenium if browser.downcase == "firefox"


#
# Environment setup
#

Capybara.run_server = false
Capybara.app_host = host
Capybara.default_wait_time = ENV["TIMEOUT"].to_i || 300


#
# Screenshot setup
#

Capybara.save_and_open_page_path = "features/screenshots"
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.append_timestamp = true
Capybara::Screenshot::RSpec.add_link_to_screenshot_for_failed_examples = true
Capybara::Screenshot::RSpec::REPORTERS["RSpec::Core::Formatters::HtmlFormatter"] = Capybara::Screenshot::RSpec::HtmlEmbedReporter

Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.gsub(' ', '-').gsub(/^.*\/feature\//,'')}"
end
