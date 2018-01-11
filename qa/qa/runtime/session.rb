module QA
  module Runtime
    class Session
      attr_reader :address

      def initialize(instance, page = nil)
        @instance = instance
        @address = host + (page.is_a?(String) ? page : page&.path)
      end

      def host
        @instance.is_a?(Symbol) ? Runtime::Scenario.send("#{@instance}_address") : @instance.to_s
      end

      def add_query_values(args)
        if args.any?
          query_string = Hash(*args).map { |key, value| "#{key}=#{value}" }.join('&')

          if query_string
            @address << (@address.index('?') ? '&' : '?')
            @address << query_string
          end
        end
      end
    end
  end
end
