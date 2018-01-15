module Gitlab
  module QueryLimiting
    # Returns true if we should enable tracking of query counts.
    #
    # This is only enabled in production/staging if we're running on GitLab.com.
    # This ensures we don't produce any errors that users can't do anything
    # about themselves.
    def self.enable?
      Gitlab.com? || Rails.env.development? || Rails.env.test?
    end
  end
end
