module Gitlab
  module Metrics
    module Concern
      class MetricOptions
        def initialize(options = {})
          @multiprocess_mode = options[:multiprocess_mode] || :all
          @buckets = options[:buckets] || ::Prometheus::Client::Histogram::DEFAULT_BUCKETS
          @base_labels = options[:base_labels] || {}
          @docstring = options[:docstring]
          @with_feature = options[:with_feature]
        end

        # Documentation describing metric in metrics endpoint '/-/metrics'
        def docstring(docstring = nil)
          @docstring = docstring unless docstring.nil?

          @docstring
        end

        # Gauge aggregation mode for multiprocess metrics
        # - :all (default) returns each gauge for every process
        # - :livesum all process'es gauges summed up
        # - :max maximum value of per process gauges
        # - :min minimum value of per process gauges
        def multiprocess_mode(mode = nil)
          @multiprocess_mode = mode unless mode.nil?

          @multiprocess_mode
        end

        # Measurement buckets for histograms
        def buckets(buckets = nil)
          @buckets = buckets unless buckets.nil?

          @buckets
        end

        # Base labels are merged with per metric labels
        def base_labels(base_labels = nil)
          @base_labels = base_labels unless base_labels.nil?

          @base_labels
        end

        # Use feature toggle to control whether certain metric is enabled/disabled
        def with_feature(name = nil)
          @feature_name = name unless name.nil?

          @feature_name
        end

        def evaluate(&block)
          instance_eval(&block) if block_given?
          self
        end
      end
    end
  end
end
