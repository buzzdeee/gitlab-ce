# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module External
        module File
          class Template < Base
            attr_reader :location, :project

            PREFIX = '~'.freeze
            SUFFIX = '.gitlab-ci.yml'.freeze

            def initialize(params, context = {})
              @location = params["template"]

              super
            end

            def content
              strong_memoize(:content) { fetch_template_content }
            end

            private

            def validate_location!
              super

              unless template_name
                errors.push("Template file `#{location}` does not have a valid location!")
              end
            end

            def template_name
              return unless location
              return unless location.start_with?(PREFIX)
              return unless location.end_with?(SUFFIX)

              location[PREFIX.length..-SUFFIX.length]
            end

            def fetch_template_content
              Gitlab::Template::GitlabCiYmlTemplate.find(template_name, project)&.content
            end
          end
        end
      end
    end
  end
end
