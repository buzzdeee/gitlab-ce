# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module External
        class Mapper
          include Gitlab::Utils::StrongMemoize

          FILE_CLASSES = [
            External::File::Remote,
            External::File::Template,
            External::File::Local
          ].freeze

          AmbigiousSpecificationError = Class.new(StandardError)

          def initialize(values, project:, sha:, user:)
            @locations = Array(values.fetch(:include, []))
            @project = project
            @sha = sha
            @user = user
          end

          def process
            locations
              .map(&method(:normalize_location))
              .map(&method(:find_all_matching))
              .map(&method(:select_first_matching))
          end

          private

          attr_reader :locations, :project, :sha, :user

          # convert location if String to canonical form
          def normalize_location(location)
            if location.is_a?(String)
              normalize_location_string(location)
            else
              location
            end
          end

          def normalize_location_string(location)
            if ::Gitlab::UrlSanitizer.valid?(location)
              { "remote" => location }
            else
              { "file" => location }
            end
          end

          def find_all_matching(location)
            FILE_CLASSES.map do |file_class|
              file_class.new(location, context)
            end.select(&:matching?)
          end

          def select_first_matching(matching)
            raise AmbigiousSpecificationError unless matching.one?

            matching.first
          end

          def context
            strong_memoize(:context) do
              External::File::Base::Context.new(project, sha, user)
            end
          end
        end
      end
    end
  end
end
