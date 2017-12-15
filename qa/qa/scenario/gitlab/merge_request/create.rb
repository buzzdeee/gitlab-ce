require 'securerandom'

module QA
  module Scenario
    module Gitlab
      module MergeRequest
        class Create < Scenario::Template
          PAGE_REGEX_CHECK =
            %r{\/#{Runtime::Namespace.sandbox_name}\/qa-test[^\/]+\/{1}[^\/]+\z}.freeze

          attr_writer :title,
                      :description,
                      :source_branch,
                      :target_branch

          def initialize
            @title = 'QA test - merge request'
            @description = 'This is a test merge request'
            @source_branch = "qa-test-feature-#{SecureRandom.hex(8)}"
            @target_branch = 'master'
          end

          def perform
            Scenario::Gitlab::Project::Create.perform do |scenario|
              scenario.name = 'project_with_code'
              scenario.description = 'project with merge request'
            end

            Scenario::Gitlab::Repository::Push.perform do |scenario|
              scenario.file_name = 'README.md'
              scenario.file_content = '# This is test project'
              scenario.commit_message = 'Add README.md'
            end

            Page::Project::Show.act do |page|
              page.go_to_merge_requests
            end
          end
        end
      end
    end
  end
end
