module QA
  module Factory
    module Resource
      ##
      # Create a personal access token that can be used by the api
      # set the environment variable PERSONAL_ACCESS_TOKEN to use a
      # specific access token rather than create one from the UI
      #
      class PersonalAccessToken < Factory::Base
        attr_accessor :name

        product :access_token do
          if Runtime::Env.personal_access_token
            Runtime::Env.personal_access_token
          else
            Page::Profile::PersonalAccessTokens.act { created_access_token }
          end
        end

        def fabricate!(sign_in_address = :gitlab)
          return if Runtime::Env.personal_access_token

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
          end
        end
      end
    end
  end
end
