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

  # Instrument Sidekiq
  if Sidekiq.server?
    Sidekiq.configure_server do |config|
      config.client_middleware do |chain|
        chain.add Gitlab::Tracing::SidekiqClientMiddleware
      end

      config.server_middleware do |chain|
        chain.add Gitlab::Tracing::SidekiqServerMiddleware
      end
    end
  else
    Sidekiq.configure_client do |config|
      config.client_middleware do |chain|
        chain.add Gitlab::Tracing::SidekiqClientMiddleware
      end
    end
  end

  # In multi-processed clustered architectures (puma, unicorn) don't
  # start tracing until the worker processes are spawned. This works
  # around issues when the opentracing implementation spawns threads
  Gitlab::Cluster::LifecycleEvents.on_worker_start do
    tracer = Gitlab::Tracing::Factory.create_tracer(Sidekiq.server? ? 'sidekiq' : 'rails')
    OpenTracing.global_tracer = tracer if tracer
  end
end
