module API
  module V3
    class Version < Grape::API
      before { authenticate! }

      desc 'Get the version information of the GitLab instance.' do
        detail 'This feature was introduced in GitLab 8.13.'
      end
      get '/version' do
        { version: Gitlab::VERSION, revision: Gitlab::REVISION }
      end
    end
  end
end
