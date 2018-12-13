# frozen_string_literal: true

module ErrorTracking
  class ErrorTrackingSetting < ActiveRecord::Base
    belongs_to :project

    attr_encrypted :token,
      mode: :per_attribute_iv,
      key: Settings.attr_encrypted_db_key_base_truncated,
      algorithm: 'aes-256-gcm'

    def self.for_project(project)
      self.where(project: project).first_or_initialize
    end
  end
end
