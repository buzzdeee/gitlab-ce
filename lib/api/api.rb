module API
  class API < Grape::API
    include APIGuard

    allow_access_with_scope :api
    prefix :api

    before { header['X-Frame-Options'] = 'SAMEORIGIN' }

    # The locale is set to the current user's locale when `current_user` is loaded
    after { Gitlab::I18n.use_default_locale }

    rescue_from Gitlab::Access::AccessDeniedError do
      rack_response({ 'message' => '403 Forbidden' }.to_json, 403)
    end

    rescue_from ActiveRecord::RecordNotFound do
      rack_response({ 'message' => '404 Not found' }.to_json, 404)
    end

    # Retain 405 error rather than a 500 error for Grape 0.15.0+.
    # https://github.com/ruby-grape/grape/blob/a3a28f5b5dfbb2797442e006dbffd750b27f2a76/UPGRADING.md#changes-to-method-not-allowed-routes
    rescue_from Grape::Exceptions::MethodNotAllowed do |e|
      error! e.message, e.status, e.headers
    end

    rescue_from Grape::Exceptions::Base do |e|
      error! e.message, e.status, e.headers
    end

    rescue_from Gitlab::Auth::TooManyIps do |e|
      rack_response({ 'message' => '403 Forbidden' }.to_json, 403)
    end

    rescue_from :all do |exception|
      handle_api_exception(exception)
    end

    format :json
    content_type :txt, "text/plain"

    # Ensure the namespace is right, otherwise we might load Grape::API::Helpers
    helpers ::SentryHelper
    helpers ::API::Helpers
    helpers ::API::Helpers::CommonHelpers

    NO_SLASH_URL_PART_REGEX = %r{[^/]+}
    PROJECT_ENDPOINT_REQUIREMENTS = { id: NO_SLASH_URL_PART_REGEX }.freeze

    # Mount v3 from separate file
    mount ::API::V3::API

    version 'v4', using: :path

    # Keep in alphabetical order
    mount ::API::AccessRequests
    mount ::API::AwardEmoji
    mount ::API::Boards
    mount ::API::Branches
    mount ::API::BroadcastMessages
    mount ::API::CircuitBreakers
    mount ::API::Commits
    mount ::API::CommitStatuses
    mount ::API::DeployKeys
    mount ::API::Deployments
    mount ::API::Environments
    mount ::API::Events
    mount ::API::Features
    mount ::API::Files
    mount ::API::Groups
    mount ::API::Internal
    mount ::API::Issues
    mount ::API::Jobs
    mount ::API::Keys
    mount ::API::Labels
    mount ::API::Lint
    mount ::API::Members
    mount ::API::MergeRequestDiffs
    mount ::API::MergeRequests
    mount ::API::ProjectMilestones
    mount ::API::GroupMilestones
    mount ::API::Namespaces
    mount ::API::Notes
    mount ::API::NotificationSettings
    mount ::API::Pipelines
    mount ::API::PipelineSchedules
    mount ::API::ProjectHooks
    mount ::API::Projects
    mount ::API::ProjectSnippets
    mount ::API::ProtectedBranches
    mount ::API::Repositories
    mount ::API::Runner
    mount ::API::Runners
    mount ::API::Services
    mount ::API::Session
    mount ::API::Settings
    mount ::API::SidekiqMetrics
    mount ::API::Snippets
    mount ::API::Subscriptions
    mount ::API::SystemHooks
    mount ::API::Tags
    mount ::API::Templates
    mount ::API::Todos
    mount ::API::Triggers
    mount ::API::Users
    mount ::API::Variables
    mount ::API::GroupVariables
    mount ::API::Version

    route :any, '*path' do
      error!('404 Not Found', 404)
    end
  end
end
