module QA
  feature 'API users', :core do
    before(:context) do
      @api_client = Runtime::API::Client.new(:gitlab)
    end

    context 'when authenticated' do
      let(:request) { Runtime::API::Request.new(@api_client, '/users') }

      scenario 'get list of users' do
        get request.url, { params: { per_page: 100 } }

        expect_status(200)
        expect(json_body.detect { |item| item[:username] == Runtime::User.name }).not_to be_nil
      end

      scenario 'submit request with an invalid user name' do
        get request.url, { params: { username: 'invalid' } }

        expect_status(200)
        expect(json_body).to be_an Array
        expect(json_body.size).to eq(0)
      end
    end

    scenario 'submit request with an invalid token' do
      request = Runtime::API::Request.new(@api_client, '/users', personal_access_token: 'invalid')
      get request.url

      expect_status(401)
    end
  end
end
