# frozen_string_literal: true

module ErrorTracking
  class ErrorTrackingSetting < ActiveRecord::Base
    belongs_to :project

    validates :uri, length: { maximum: 255 }, public_url: true
    validates :token, presence: true

    attr_encrypted :token,
      mode: :per_attribute_iv,
      key: Settings.attr_encrypted_db_key_base_truncated,
      algorithm: 'aes-256-gcm'

    def self.create_or_update(project, params)
      self.transaction(requires_new: true) do
        setting = self.for_project(project)
        setting.update!(params)
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def self.for_project(project)
      self.where(project: project).first_or_initialize
    end
  end
end
