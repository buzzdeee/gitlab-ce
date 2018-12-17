# frozen_string_literal: true

require 'opentracing'

module Gitlab
  module Tracing
    class RackMiddleware
      REQUEST_URI = 'REQUEST_URI'.freeze
      REQUEST_METHOD = 'REQUEST_METHOD'.freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        tracer = OpenTracing.global_tracer
        method = env[REQUEST_METHOD]

        context = tracer.extract(OpenTracing::FORMAT_RACK, env)
        scope = tracer.start_active_span(
          method,
          child_of: context,
          tags: {
            'component' => 'rack',
            'span.kind' => 'server',
            'http.method' => method,
            'http.url' => env[REQUEST_URI]
          }
        )
        span = scope.span

        correlation_id = Gitlab::CorrelationId.current_id
        if correlation_id
          span.set_tag('correlation_id', correlation_id)
        end

        env['rack.span'] = span

        @app.call(env).tap do |status_code, _headers, _body|
          span.set_tag('http.status_code', status_code)

          route = route_from_env(env)
          span.operation_name = route if route
        end
      rescue StandardError => e
        span.set_tag('error', true)
        span.log_kv(
          event: 'error',
          :'error.kind' => e.class.to_s,
          :'error.object' => e,
          message: e.message,
          stack: e.backtrace.join("\n")
        )
        raise
      ensure
        scope.close
      end

      private

      def route_from_env(env)
        env['sinatra.route']
      end
    end
  end
end
