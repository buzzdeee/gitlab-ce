# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module External
        module File
          class Local < Base
            include Gitlab::Utils::StrongMemoize

            attr_reader :project, :ref

            def initialize(params, context = {})
              @location = params["file"]
              @project = params["project"]
              @ref = params["ref"]

              if @project
                @ref ||= 'HEAD'
              else
                @project = context.project.full_path
                @ref ||= context.sha
              end

              super
            end

            def content
              strong_memoize(:content) { fetch_local_content }
            end

            private

            def validate_content!
              if !can_access_local_content?
                errors.push("Permission denied accessing `#{project}`!")
              elsif content.nil?
                errors.push("Local file `#{location}` does not exist!")
              elsif content.blank?
                errors.push("Local file `#{location}` is empty!")
              end
            end

            def local_project
              strong_memoize(:local_project) do
                Project.find_by_full_path(@project)
              end
            end

            def can_access_local_content?
              Ability.allowed?(context.user, :download_code, local_project)
            end

            def fetch_local_content
              return unless can_access_local_content?

              local_project.repository.blob_data_at(ref, location)
            end
          end
        end
      end
    end
  end
end
