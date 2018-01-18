module QA
  feature 'API users', :core do
    include Support::ApiHelpers

    before(:context) do
      Runtime::Browser.visit(:gitlab, Page::Main::Login)
      Page::Main::Login.act { sign_in_using_credentials }
      @access_token = Factory::Resource::PersonalAccessToken.fabricate!.access_token
    end

    context 'when authenticated' do
      let(:session) { Runtime::Session.new(:gitlab, api('/users', personal_access_token: @access_token)) }

      scenario 'get list of users' do
        get session.address
        expect_status(200)
      end

      scenario 'submit request with an invalid user name' do
        get session.address, { params: { username: 'invalid' } }
        expect_status(200)
        expect(json_body).to be_an Array
        expect(json_body.size).to eq(0)
      end
    end

    scenario 'submit request with an invalid token' do
      session = Runtime::Session.new(:gitlab, api('/users', personal_access_token: 'invalid'))
      get session.address

      expect_status(401)
    end
  end
end
