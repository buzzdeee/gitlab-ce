module QA
  feature 'creates a merge request', :core do
    scenario 'user creates a new merge request'  do
      Runtime::Browser.visit(:gitlab, Page::Main::Login)
      Page::Main::Login.act { sign_in_using_credentials }

      Scenario::Gitlab::MergeRequest::Create.perform do |scenario|
        puts "performou"
      end

      expect(page).to have_content('README.md')
      expect(page).to have_content('This is test project')
    end
  end
end
