require 'faraday'

module QA
  module Runtime
    class API
      ##
      # GET an endpoint that belongs to a GitLab instance under a given address
      #
      # Example:
      #
      # get(:gitlab, api('/users', personal_access_token: 'something'))
      # get('http://gitlab.example', '/api/v4/users?private_token=something')
      #
      # In case of an address that is a symbol we will try to guess address
      # based on `Runtime::Scenario#something_address`.
      def self.get(address, page)
        Faraday.get API::Session.new(address, page).address
      end

      def self.version
        'v4'
      end

      class Session
        def initialize(instance, page = nil)
          @instance = instance
          @address = host + (page.is_a?(String) ? page : page&.path)
        end

        def host
          @instance.is_a?(Symbol) ? Runtime::Scenario.send("#{@instance}_address") : @instance.to_s
        end

        def address
          @address
        end
      end
    end
  end
end
