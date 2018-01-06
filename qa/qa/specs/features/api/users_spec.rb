module QA
  feature 'API users', :core do
    include Support::ApiHelpers

    before(:context) do
      product = Factory::Resource::PersonalAccessToken.fabricate!
      @access_token = product.factory.access_token
    end

    context "when authenticated" do
      scenario 'get list of users' do
        response, _json = Runtime::API.get(:gitlab, api('/users', personal_access_token: @access_token))
        expect(response).to have_gitlab_api_status(200)
      end

      scenario 'returns an empty response when an invalid `username` parameter is passed' do
        response, json = Runtime::API.get(:gitlab, api('/users', personal_access_token: @access_token),
                                          username: 'invalid')

        expect(response).to have_gitlab_api_status(200)
        expect(json).to be_an Array
        expect(json.size).to eq(0)
      end
    end

    scenario "returns authorization error when token is invalid" do
      response, _json = Runtime::API.get(:gitlab, api('/users', personal_access_token: 'invalid'))

      expect(response).to have_gitlab_api_status(401)
    end
  end
end
