# Create a personal access token that can be used by the api
# set the environment variable PERSONAL_ACCESS_TOKEN to use a
# specific access token rather than create one from the UI
module QA
  module Factory
    module Resource
      class PersonalAccessToken < Factory::Base
        attr_accessor :name, :access_token

        def fabricate!(sign_in_address = :gitlab)
          @access_token = Runtime::Env.personal_access_token
          return if @access_token

          if sign_in_address
            Runtime::Browser.visit(sign_in_address, Page::Main::Login)
            Page::Main::Login.act { sign_in_using_credentials }
          end

          Page::Menu::Main.act { go_to_profile_settings }
          Page::Menu::Profile.act { click_access_tokens }

          Page::Profile::PersonalAccessTokens.perform do |page|
            page.fill_token_name(name || 'api-test-token')
            page.check_api
            page.create_token
            @access_token = page.created_access_token
          end

          if sign_in_address
            Page::Menu::Main.act { sign_out }
          end
        end
      end
    end
  end
end
