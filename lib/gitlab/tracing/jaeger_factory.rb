# frozen_string_literal: true

require 'jaeger/client'
require 'jaeger/client/http_sender'

module Gitlab
  module Tracing
    module JaegerFactory
      def self.create_tracer(service_name, options)
        encoder = Jaeger::Client::Encoders::ThriftEncoder.new(service_name: service_name)
        sender = Jaeger::Client::HttpSender.new(
          url: "http://localhost:14268/api/traces",
          encoder: encoder,
        )

        Jaeger::Client.build(
          service_name: service_name,
          flush_interval: 5,
          sender: sender,
          sampler: Jaeger::Client::Samplers::Const.new(true)
        )
      end
    end
  end
end
