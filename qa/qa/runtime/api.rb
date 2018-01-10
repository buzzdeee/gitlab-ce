module QA
  module Runtime
    module API
      VERSION = 'v4'.freeze

      class Client
        ##
        # GET an endpoint that belongs to a GitLab instance under a given address
        #
        # Example:
        #
        # get(:gitlab, api('/users', personal_access_token: 'something'))
        # get(:gitlab, api('/users', personal_access_token: 'something'), username: value, ...)
        # get('http://gitlab.example', '/api/v4/users?private_token=something')
        #
        # In case of an address that is a symbol we will try to guess address
        # based on `Runtime::Scenario#something_address`.
        def self.get(address, page, *args)
          page = self.add_query_values(page, args)
          API::Response.new(Faraday.get(API::Client::Session.new(address, page).address))
        end

        def self.add_query_values(path, args)
          if args.any?
            query_string = Hash(*args).map { |key, value| "#{key}=#{value}" }.join('&')

            if query_string
              path << (path.index('?') ? '&' : '?')
              path << query_string
            end
          end
          path
        end

        class Session
          attr_reader :address

          def initialize(instance, page = nil)
            @instance = instance
            @address = host + (page.is_a?(String) ? page : page&.path)
          end

          def host
            @instance.is_a?(Symbol) ? Runtime::Scenario.send("#{@instance}_address") : @instance.to_s
          end
        end
      end

      class Response
        attr_reader :response, :json

        def initialize(response)
          @response = response
          @json = @response.status == 200 ? JSON.parse(@response.body) : nil
        end
      end
    end
  end
end
