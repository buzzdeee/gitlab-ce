# frozen_string_literal: true

module Gitlab
  module CorrelationId
    def self.use_id(correlation_id, &blk)
      ids.push(correlation_id) if correlation_id

      begin
        yield(last_id)
      ensure
        ids.pop if correlation_id
      end
    end

    def self.last_id
      ids.last
    end

    private

    def self.ids
      Thread.current[:correlation_id] ||= []
    end
  end
end
