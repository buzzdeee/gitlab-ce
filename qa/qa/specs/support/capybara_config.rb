module QA
  module Specs
    module Support
      module CapybaraConfig
        def configure_capybara
          return if Capybara.drivers.include?(:chrome)

          Capybara.register_driver :chrome do |app|
            capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
              # This enables access to logs with `page.driver.manage.get_log(:browser)`
              loggingPrefs: {
                browser: "ALL",
                client: "ALL",
                driver: "ALL",
                server: "ALL"
              }
            )

            options = Selenium::WebDriver::Chrome::Options.new
            options.add_argument("window-size=1240,1680")

            # Chrome won't work properly in a Docker container in sandbox mode
            options.add_argument("no-sandbox")

            # Run headless by default unless CHROME_HEADLESS specified
            unless ENV['CHROME_HEADLESS'] =~ /^(false|no|0)$/i
              options.add_argument("headless")

              # Chrome documentation says this flag is needed for now
              # https://developers.google.com/web/updates/2017/04/headless-chrome#cli
              options.add_argument("disable-gpu")
            end

            # Disable /dev/shm use in CI. See https://gitlab.com/gitlab-org/gitlab-ee/issues/4252
            options.add_argument("disable-dev-shm-usage") if ENV['CI'] || ENV['CI_SERVER']

            Capybara::Selenium::Driver.new(
              app,
              browser: :chrome,
              desired_capabilities: capabilities,
              options: options
            )
          end

          # Keep only the screenshots generated from the last failing test suite
          Capybara::Screenshot.prune_strategy = :keep_last_run

          # From https://github.com/mattheworiordan/capybara-screenshot/issues/84#issuecomment-41219326
          Capybara::Screenshot.register_driver(:chrome) do |driver, path|
            driver.browser.save_screenshot(path)
          end

          Capybara.configure do |config|
            config.default_driver = :chrome
            config.javascript_driver = :chrome
            config.default_max_wait_time = 10
            # https://github.com/mattheworiordan/capybara-screenshot/issues/164
            config.save_path = 'tmp'
          end
        end
      end
    end
  end
end
