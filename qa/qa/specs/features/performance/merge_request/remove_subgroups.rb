# frozen_string_literal: true

module QA
  context 'Plan' do
    describe 'Epics milestone dates API' do
      before(:context) do
        @api_client = Runtime::API::Client.new(:gitlab)

      end

      def create_request(api_endpoint)
        Runtime::API::Request.new(@api_client, api_endpoint)
      end

      it 'Delete groups' do
        request = create_request("/groups/#{Runtime::Namespace.sandbox_name}/subgroups")
        get request.url
        while(json_body.count > 0) do
          json_body.each do |grp|
            puts grp[:id]
            r = create_request("/groups/#{grp[:id]}")
            delete r.url
          end
          request = create_request("/groups/#{Runtime::Namespace.sandbox_name}/subgroups")
          get request.url
        end
      end

    end
  end
end
