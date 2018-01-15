module Gitlab
  module QueryLimiting
    # Middleware for reporting (or raising) when a request performs more than a
    # certain amount of database queries.
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        transaction, retval = Transaction.run do
          @app.call(env)
        end

        transaction.act_upon_results

        retval
      end
    end
  end
end
