module QA
  module Page
    module Menu
      class UserSettings < Page::Base
        def click_access_tokens
          within_sidebar do
            click_link('Access Tokens')
          end
        end

        private

        def within_sidebar
          page.within('.sidebar-top-level-items') do
            yield
          end
        end
      end
    end
  end
end
