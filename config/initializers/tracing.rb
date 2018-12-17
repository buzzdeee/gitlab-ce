# frozen_string_literal: true

if Gitlab::Tracing.enabled?
  require 'opentracing'

  Rails.application.configure do |config|
    config.middleware.insert_after Gitlab::Middleware::CorrelationId, ::Gitlab::Tracing::RackMiddleware
  end

  # Instrument Redis calls
  Gitlab::Tracing::Redis.instrument_client

  # Instrument Rails
  Gitlab::Tracing::Rails.instrument

  Gitlab::Cluster::LifecycleEvents.on_worker_start do
    tracer = Gitlab::Tracing::Factory.create_tracer(Sidekiq.server? ? "sidekiq" : "rails")
    OpenTracing.global_tracer = tracer if tracer
  end
end
