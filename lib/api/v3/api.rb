module API
  module V3
    class API < Grape::API
      version 'v3', using: :path do
        helpers ::API::V3::Helpers
        helpers ::API::Helpers::CommonHelpers

        mount ::API::V3::AwardEmoji
        mount ::API::V3::Boards
        mount ::API::V3::Branches
        mount ::API::V3::BroadcastMessages
        mount ::API::V3::Builds
        mount ::API::V3::Commits
        mount ::API::V3::DeployKeys
        mount ::API::V3::Environments
        mount ::API::V3::Files
        mount ::API::V3::Groups
        mount ::API::V3::Issues
        mount ::API::V3::Labels
        mount ::API::V3::Members
        mount ::API::V3::MergeRequestDiffs
        mount ::API::V3::MergeRequests
        mount ::API::V3::Notes
        mount ::API::V3::Pipelines
        mount ::API::V3::ProjectHooks
        mount ::API::V3::Milestones
        mount ::API::V3::Projects
        mount ::API::V3::ProjectSnippets
        mount ::API::V3::Repositories
        mount ::API::V3::Runners
        mount ::API::V3::Services
        mount ::API::V3::Settings
        mount ::API::V3::Snippets
        mount ::API::V3::Subscriptions
        mount ::API::V3::SystemHooks
        mount ::API::V3::Tags
        mount ::API::V3::Templates
        mount ::API::V3::Todos
        mount ::API::V3::Triggers
        mount ::API::V3::Users
        mount ::API::V3::Variables
      end
    end
  end
end
