module QA
  feature 'API users', :core do
    include Support::ApiHelpers

    before(:context) do
      product = Factory::Resource::PersonalAccessToken.fabricate!
      @access_token = product.factory.access_token
    end

    context "when authenticated" do
      scenario 'get list of users' do
        response = Runtime::API::Client.get(:gitlab, api('/users', personal_access_token: @access_token))
        expect(response.response).to have_gitlab_api_status(200)
      end

      scenario 'returns an empty response when an invalid `username` parameter is passed' do
        response = Runtime::API::Client.get(:gitlab, api('/users', personal_access_token: @access_token),
                                            username: 'invalid')

        expect(response.response).to have_gitlab_api_status(200)
        expect(response.json).to be_an Array
        expect(response.json.size).to eq(0)
      end
    end

    scenario "returns authorization error when token is invalid" do
      response = Runtime::API::Client.get(:gitlab, api('/users', personal_access_token: 'invalid'))

      expect(response.response).to have_gitlab_api_status(401)
    end
  end
end
