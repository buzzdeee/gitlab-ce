# frozen_string_literal: true

module Gitlab
  module Tracing
    @@configured = false

    def self.enabled?
      return true
    end

    def self.configured?
      return enabled? && @@configured
    end

    def self.configured=(value)
      @@configured = value
    end

  end
end

