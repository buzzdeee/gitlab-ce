require 'rspec/core'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'selenium-webdriver'

module QA
  module Runtime
    class Browser
      include QA::Scenario::Actable
      extend  QA::Specs::Support::CapybaraConfig

      def initialize
        self.class.configure!
      end

      ##
      # Visit a page that belongs to a GitLab instance under given address.
      #
      # Example:
      #
      # visit(:gitlab, Page::Main::Login)
      # visit('http://gitlab.example/users/sign_in')
      #
      # In case of an address that is a symbol we will try to guess address
      # based on `Runtime::Scenario#something_address`.
      #
      def visit(address, page, &block)
        Browser::Session.new(address, page).tap do |session|
          session.perform(&block)
        end
      end

      def self.visit(address, page, &block)
        new.visit(address, page, &block)
      end

      def self.configure!
        self.configure_capybara
      end

      class Session
        include Capybara::DSL

        def initialize(instance, page = nil)
          @instance = instance
          @address = host + page&.path
        end

        def host
          if @instance.is_a?(Symbol)
            Runtime::Scenario.send("#{@instance}_address")
          else
            @instance.to_s
          end
        end

        def perform(&block)
          visit(@address)

          yield if block_given?
        rescue
          raise if block.nil?

          # RSpec examples will take care of screenshots on their own
          #
          unless block.binding.receiver.is_a?(RSpec::Core::ExampleGroup)
            screenshot_and_save_page
          end

          raise
        ensure
          clear! if block_given?
        end

        ##
        # Selenium allows to reset session cookies for current domain only.
        #
        # See gitlab-org/gitlab-qa#102
        #
        def clear!
          visit(@address)
          reset_session!
        end
      end
    end
  end
end
