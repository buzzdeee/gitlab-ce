module QA
  module Page
    module User
      module Settings
        class AccessTokens < Page::Base
          def fill_token_name(name)
            fill_in 'personal_access_token_name', with: name
          end

          def check_api
            check 'personal_access_token_scopes_api'
          end

          def create_token
            click_on 'Create personal access token'
          end

          def created_access_token
            page.find('#created-personal-access-token').value
          end
        end
      end
    end
  end
end
